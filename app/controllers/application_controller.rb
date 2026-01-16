class ApplicationController < ActionController::Base
  include JsonWebToken
  include ActionController::MimeResponds
  include ActionController::Cookies

  before_action :authorize_request  
  before_action :set_current_user
  helper_method :current_user, :logged_in?
  
  def set_current_user
    if session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
    else
      @current_user = nil
    end
  end
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

  def current_user
    @current_user
  end
  
  def logged_in?
    current_user.present?
  end

  def require_login
    unless logged_in?
      flash[:alert] = "Please login first"
      redirect_to '/api/auth/login'
    end
  end
  
end
