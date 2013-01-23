class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to :html, :xml, :tablet, :json 
  
  before_filter :prepare_for_tablet
  helper_method :resource, :resource_name, :devise_mapping, :tablet_device?
    
  before_filter :pusher, :only => [:turnPage]
  before_filter :initialize_mixpanel
  
  def index 
     @earlyUser = EarlyUser.new
  end
  
  def earlyAccess
    user2 = params[:user2]
    
    unless params[:early_user][:email].blank? 
      earlyUser = EarlyUser.find_or_create_by_email(params[:early_user])
      puts 'here1'
      if earlyUser.qualifies? and !user2[:email2].blank? 
        if user2[:email2] == params[:early_user][:email]
          render :json => {:message=>"error-email"}
          return
        else
          puts "here"
          user1 = User.find_or_create_by_email(:email => params[:early_user][:email], 
                               :password => "rg", 
                               :username => params[:early_user][:username],
                               :status => User::WAITING_FOR_UDID)
          user2 = User.find_or_create_by_email(:email => user2[:email2], 
                               :password => "rg", 
                               :username => user2[:username2], 
                               :status => User::WAITING_FOR_UDID)
          if user2.save and user1.save                 
            user1.friendships.create!(:friend_id => user2.id)
            UserMailer.betauser_welcome(user1).deliver
            UserMailer.betainvitee_welcome(user1, user2).deliver

            render :json => {:message=>"active_user"}
            return
          else
            render :json => {:message=>"error-email"}
            return
          end
        end
      else      
        if earlyUser.save
          UserMailer.earlyuser_welcome(earlyUser).deliver
          render :json => {:message=>"early_user"} 
          return
        else 
          render :json => {:message=>"error-fields"}
          return
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
  
  # PLAYDATE SHARED METHODS
  
  # expected params: book_id, page_num
  # sends change_book pusher event
  def changeBook
    getBook(params[:book_id])
    if @book.blank? 
      return false;
    end
    @playdate.page_num = params[:page_num]
    @playdate.save
    Pusher[@playdate.pusher_channel_name].trigger('change_book', {
      :data => @book.to_json(:include => :pages),
      :book => @book.id,
      :player => current_user.id,
      :page => params[:page_num]
    })
  end
  
  # loads a book for a playdate.   
  def getBook(id)
    @book = Book.find(id)
    if @book.blank?
      return false
    end
    @playdate.book_id = id
    @playdate.save
  end
  
  # expected params: new_page_num
  # sends a pusher event to turn to new_page_num
  def turnPage
    @playdate.page_num = params[:new_page_num]
    @playdate.save
    Pusher[@playdate.pusher_channel_name].trigger('turn_page', {
      :player => current_user.id,
      :page => params[:new_page_num]
    })
  end
  
  # sends a pusher event to close book
  def closeBook
    Pusher[@playdate.pusher_channel_name].trigger('close_book', {
      :player => current_user.id,
      :book => params[:book_id],
    })
  end
  
  # sends a pusher event on playdate channel to end playdate
  def endPlaydate
    # Channel notification to players in this playdate
    Pusher[@playdate.pusher_channel_name].trigger('end_playdate', {:playdate => @playdate.id, :player => current_user.id})
    
    # Rendezvous notification to everyone else
    initiator = User.find(@playdate.player1_id)
    playmate = User.find(@playdate.player2_id)
    Pusher["presence-rendezvous-channel"].trigger('playdate_ended', {
      :playdateID           => @playdate.id,
      :pusherChannelName    => @playdate.pusher_channel_name,
      :initiatorID          => initiator.id,
      :initiator            => initiator.username,
      :playmateID           => playmate.id,
      :playmateName         => playmate.username,
      :tokboxSessionID      => @playdate.video_session_id,
      :tokboxInitiatorToken => @playdate.tokbox_initiator_token,
      :tokboxPlaymateToken  => @playdate.tokbox_playmate_token
    })
    
    # DB update
    @playdate.disconnect
  end

  private
  def initialize_mixpanel
    @mixpanel = Mixpanel::Tracker.new(ENV['MIXPANEL_KEY'], { :env => request.env })
  end
  
end
