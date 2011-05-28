class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  
protected  
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def authorize
    unless current_user
      flash.now.alert = "Please log in"
      redirect_to login_path
    end
  end
end
