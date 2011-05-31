class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :playdateExists
  
private  
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def authorize
    unless current_user
      flash.now.alert = "Please log in"
      redirect_to login_path
    end
  end
  
  # returns the playdate if there is a playdate session for the current user in the db
  def playdateExists
    Playdate.findPlaydate(current_user)
  end
end
