class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_subjects
  before_action :authorize

  delegate :permit?, to: :current_permission
  helper_method :permit?
  
  private
  helper_method :current_user
  
  def set_subjects
  	@subjects = Subject.all
  end
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def current_resource
    nil
  end
  
  def current_permission
    @current_permission ||= Permission.new(current_user)
  end
  
  def authorize
    if !current_permission.permit?(params[:controller], params[:action], current_resource)
      redirect_to root_url
    end
  end
  
  def author?
    current_user && current_user.has_role?("Author")
  end
  
  helper_method :author?
end
