class ApplicationController < ActionController::API
  include JsonWebToken
  include ActionController::MimeResponds

  before_action :authorize_request

  def authorize_request
    if request.headers['Authorization'].present?
      header = request.headers['Authorization']
      header = header.split(' ').last if header

      begin
        @decoded = JsonWebToken.decode(header)
        @current_user = User.find(@decoded[:user_id])
      rescue ActiveRecord::RecordNotFound
        render_unauthorized
      rescue JWT::DecodeError
        render_unauthorized
      end
    elsif session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
    end
  end

  def owner?(model)
    model.user_id == @current_user&.id
  end

  def render_unauthorized
    render json: { errors: 'Unauthorized' }, status: :unauthorized
  end
end
