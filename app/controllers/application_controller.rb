class ApplicationController < ActionController::Base
  protect_from_forgery
  #helper_method :current_user
  helper_method :resource, :resource_name, :devise_mapping
  
  def index 
     @earlyUser = EarlyUser.new
  end
  
  def earlyAccess
    if !params[:early_user][:email].blank?
      @earlyUser = EarlyUser.new(params[:early_user])
      @earlyUser.save
    end
    respond_to do |format|
      format.js
    end
  end
    
private  

  def resource_name
    :user
  end
 
  def resource
    @resource ||= User.new
  end
 
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
  
  def after_sign_in_path_for(user)
      user_path user.id
  end
  
  #def current_user
  #  @current_user ||= User.find(session[:user_id]) if session[:user_id]
  #end
  
  #def authorize
  #  unless current_user
  #    flash.now.alert = "Please log in"
  #   redirect_to login_path
  #  end
  #end
  
  # returns the playdate if there is a playdate request for the current user. should be used only when checking for a playdate request (not to get the current playdate session)
  def requesting_playdate
    @playdate ||= Playdate.findActivePlaydate(current_user) 
  end
  
  # returns the playdate currently in the session
  def current_playdate
    @playdate ||= Playdate.find(session[:playdate])
  end
end
