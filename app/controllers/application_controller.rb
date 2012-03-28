class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to :html, :xml, :tablet, :json 
  
  before_filter :prepare_for_tablet
  helper_method :resource, :resource_name, :devise_mapping, :tablet_device?
    
  def index 
     @earlyUser = EarlyUser.new
  end
  
  def earlyAccess
    user2 = params[:user2]
    
    unless params[:early_user][:email].blank? 
      earlyUser = EarlyUser.create(params[:early_user])

      if earlyUser.qualifies? and !user2[:email2].blank?
        user1 = User.create!(:email => params[:early_user][:email], 
                             :password => "rg", 
                             :username => params[:early_user][:username],
                             :status => User::WAITING_FOR_UDID)
        user2 = User.create!(:email => user2[:email2], 
                             :password => "rg", 
                             :username => user2[:username2], 
                             :status => User::WAITING_FOR_UDID)
        user1.friendships.create!(:friend_id => user2.id)

        UserMailer.betauser_welcome(user1).deliver
        UserMailer.betainvitee_welcome(user1, user2).deliver

        render :json => {:message=>"active_user"}
        return
      #elsif !user2[:email2].blank?
        #create earlyUser for user2
      else      
        puts "attempting to save"
        if earlyUser.save
          UserMailer.earlyuser_welcome(earlyUser).deliver
          render :json => {:message=>"early_user"} 
          return
        else 
          puts earlyUser.errors
          #return errors
        end
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
