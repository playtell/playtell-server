class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to :html, :xml, :tablet, :json 
  
  before_filter :prepare_for_tablet
  helper_method :resource, :resource_name, :devise_mapping, :tablet_device?
    
  def index 
     @earlyUser = EarlyUser.new
  end
  
  def earlyAccess
    unless params[:email].blank?
      if params[:email2].blank?
        earlyUser = EarlyUser.new(:email => params[:email])
        if earlyUser.save
          render :json => true 
          return
        end
      else
        user1 = User.create!(:email => params[:email], :password => "rg")
        user2 = User.create!(:email => params[:email2], :password => "rg")
        user1.waiting_for_udid
        user2.waiting_for_udid
        user1.friendships.create!(:friend_id => user2.id)
        #send emails
        render :json => true
        return
      end
    end
    render :json => false
  end
  
  def timeline
  end
    
private  

  def tablet_device?
    request.user_agent =~ /iPad/
  end
  
  def prepare_for_tablet
    #request.format = :tablet if tablet_device?
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
  
  def save_path_and_authenticate_user
    if current_user.blank?
      session[:user_return_to] = request.url
      authenticate_user!
    end
  end
  
  def after_sign_in_path_for(user)
    if !params[:device_token].blank?
      d = DeviceToken.find_or_create_by_user_id({ :user_id => user.id })
      if d.token != params[:device_token]
        d.token = params[:device_token] 
        d.save!
        Urbanairship.register_device(params[:device_token])
      end
    end
    
    if session[:user_return_to]
      sign_in_url = url_for(:action => 'new', :controller => '/sessions', :only_path => false, :protocol => 'http')     
      session[:user_return_to] if session[:user_return_to] != sign_in_url
    else
      user_path user.id
    end
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
