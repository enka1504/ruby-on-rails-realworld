class CommentsController < ApplicationController
  before_action :set_comment!, only: %i[show update destroy edit]
  before_action :set_article!, only: %i[index create]
  before_action :require_login, only: %i[new create edit update destroy]

  def index
    @comments = Comment.all
    respond_to do |format|
      format.html
      format.json { render json: { comments: Comment.all } }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @comment }
    end
  end

  def new
    @comment = Comment.new
  end

  def create
    @comment = @article.comments.new(comment_params.merge({ user_id: @current_user.id }))

    if @comment.save
      respond_to do |format|
        format.html { redirect_to @article, notice: 'Comment was successfully created.' }
        format.json { render json: @comment.as_json({}, @current_user), status: :created, location: @comment }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      respond_to do |format|
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render json: @comment }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_path, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_article!
    @article = Article.find_by_slug!(params[:article_slug])
  end

  def set_comment!
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def require_login
    unless @current_user
      respond_to do |format|
        format.html { redirect_to login_path, alert: 'You must be logged in' }
        format.json { render json: { errors: 'Unauthorized' }, status: :unauthorized }
      end
    end
  end
end
end
