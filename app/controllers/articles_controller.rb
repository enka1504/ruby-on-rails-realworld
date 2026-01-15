class ArticlesController < ApplicationController
  before_action :set_article!, only: %i[show update destroy favorite unfavorite edit]
  before_action :require_login, only: %i[new create edit update destroy]

  def index
    @articles = Article.order(created_at: :desc).includes(:user)

    @articles = @articles.offset(params[:offset]).limit(params[:limit]) if params[:offset].present? and params[:limit].present?
    @articles = @articles.fitler_by_tag(params[:tag]) if params[:tag].present?
    @articles = @articles.filter_by_author(params[:author]) if params[:author].present?
    @articles = @articles.filter_by_favorited(params[:favorited]) if params[:favorited].present?

    respond_to do |format|
      format.html
      format.json { render json: { articles: @articles, articlesCount: @articles.count } }
    end
  end

  def feed
    @articles = Article.order(created_at: :desc).where(user: @current_user.followers).includes(:user)

    render_articles
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: { article: @article.as_json({}, @current_user) } }
    end
  end

  def new
    @article = Article.new
  end

  def create
    @article = @current_user.articles.new(article_params.except(:tagList))

    if @article.save
      @article.sync_tags(article_params[:tagList])

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

  def create
    @article = @current_user.articles.new(article_params.except(:tagList))

    if @article.save
      @article.sync_tags(article_params[:tagList])

      render_article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  def update
    unless owner?(@article)
      render_unauthorized and return
    end

    if @article.update(article_params)
      render_article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  def destroy
    unless owner?(@article)
      render_unauthorized and return
    end

    @article.destroy
  end

  def favorite
    @article.favorite @current_user

    render_article
  end

  def unfavorite
    @article.unfavorite @current_user

    render_article
  end

  private

  def set_article!
    @article = Article.find_by_slug(params[:slug])
  end

  def article_params
    params.require(:article).permit(:title, :description, :body, tagList: [])
  end

  def require_login
    unless @current_user
      respond_to do |format|
        format.html { redirect_to login_path, alert: 'You must be logged in' }
        format.json { render json: { errors: 'Unauthorized' }, status: :unauthorized }
      end
    end
  end

  def render_article
    render json: { article: @article.as_json({}, @current_user) }
  end

  def render_articles
    render json: { articles: @articles, articlesCount: @articles.count }
  end
end
