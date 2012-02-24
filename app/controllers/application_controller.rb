class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to :html, :xml, :tablet, :json 
  
  before_filter :prepare_for_tablet
  helper_method :resource, :resource_name, :devise_mapping, :tablet_device?
    
  def index 
     @earlyUser = EarlyUser.new
  end
  
  def earlyAccess
    if !params[:email].blank?
      earlyUser = EarlyUser.new(:email => params[:email])
      earlyUser.save
      respond_to do |format|
        format.json { head :ok } 
        format.tablet { head :ok }
      end
    end
  end
    
private  

  def tablet_device?
    request.user_agent =~ /iPad/
  end
  
  def prepare_for_tablet
    request.format = :tablet if tablet_device?
  end

  # for use with devise
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
    if params[:device_token]
      DeviceToken.find_or_create_by_token_and_user_id({:user_id => user.id, :token => params[:device_token]})
    end
    user_path user.id
  end
  
  # returns the playdate if there is a playdate request for the current user. should be used only when checking for a playdate request (not to get the current playdate session)
  def requesting_playdate
    @playdate ||= Playdate.findActivePlaydate(current_user) 
  end
  
  # returns the playdate currently in the session
  def current_playdate
    @playdate ||= Playdate.find(session[:playdate])
  end
  
  def pusher
    if !@pusher_key
      @pusher_key = Pusher.key
    end
  end
  
end
