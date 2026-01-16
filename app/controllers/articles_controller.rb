class ArticlesController <  ApplicationController
  # skip_before_action :authorize_request, only: [:show], raise: false
  before_action :set_article!, only: %i[show update destroy favorite unfavorite edit]
  before_action :authorize_request, only: [:show, :new, :create, :edit, :update, :destroy], raise: false
  # before_action :require_login, only: [:new, :create, :edit, :update, :destroy]

  def index
    @articles = Article.order(created_at: :desc).includes(:user)
    @articles = @articles.offset(params[:offset]).limit(params[:limit]) if params[:offset].present? && params[:limit].present?
    @articles = @articles.fitler_by_tag(params[:tag]) if params[:tag].present?
    @articles = @articles.filter_by_author(params[:author]) if params[:author].present?
    @articles = @articles.filter_by_favorited(params[:favorited]) if params[:favorited].present?
    respond_to do |format|
      format.html
      format.json { render json: { articles: @articles, articlesCount: @articles.count } }
    end
  end

  def feed
    return unless @current_user
    @articles = Article.order(created_at: :desc).where(user: @current_user.following).includes(:user)

    respond_to do |format|
      format.html
      format.json { render json: { articles: @articles, articlesCount: @articles.count } }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: { article: @article.as_json({}, @current_user) } }
    end
  end

  def new
    # @article = Article.new
  end

  def create

    @article = @current_user.articles.new(article_params)
    if @article.save
      respond_to do |format|
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render json: { article: @article.as_json({}, @current_user) } }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    # Simple render edit.html.erb
  end

  def update
    unless owner?(@article)
      respond_to do |format|
        format.html { redirect_to articles_path, alert: 'Not authorized' }
        format.json { render json: { errors: 'Unauthorized' }, status: :unauthorized }
      end
      return
    end

    if @article.update(article_params)
      respond_to do |format|
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render json: { article: @article.as_json({}, @current_user) } }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    unless owner?(@article)
      respond_to do |format|
        format.html { redirect_to articles_path, alert: 'Not authorized' }
        format.json { render json: { errors: 'Unauthorized' }, status: :unauthorized }
      end
      return
    end

    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_path, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def favorite
    @article.favorite(@current_user)
    render json: { article: @article.as_json({}, @current_user) }
  end

  def unfavorite
    @article.unfavorite(@current_user)
    render json: { article: @article.as_json({}, @current_user) }
  end

  private

  def set_article!
    @article = Article.find_by_slug!(params[:slug])  # Added ! to raise exception if not found
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to articles_path, alert: 'Article not found' }
      format.json { render json: { errors: 'Article not found' }, status: :not_found }
    end
  end

  def article_params
    if params[:article]
      params.require(:article).permit(:title, :description, :body)
    else
      params.permit(:title, :description, :body)
    end
  end

  def require_login
    unless @current_user
      respond_to do |format|
        format.html { redirect_to login_path, alert: 'You must be logged in' }
        format.json { render json: { errors: 'Unauthorized' }, status: :unauthorized }
      end
    end
  end

  def owner?(article)
    @current_user && article.user == @current_user
  end
end