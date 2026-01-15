class TagsController < ApplicationController
  skip_before_action :authorize_request, raise: false

  def index
    @tags = Tag.all
    respond_to do |format|
      format.html
      format.json { render json: { tags: Tag.pluck(:name) } }
    end
  end
end
