class GamesController < ApplicationController
  before_filter :initOpenTok, :pusher, :only => [:playdate]
  before_filter :save_path_and_authenticate_user
  layout :chooseLayout
      
  @@opentok = nil

  # main method to connect users with playdates. creates a new playdate, or adds user to existing playdate.
  def playdate
    if params[:playdate] || requesting_playdate
      joinPlaydate
    else
      createPlaydate
      sendInvite
    end
    @books = Book.all
    @feedback = Feedback.new
    @playdatePhoto = PlaydatePhoto.new
  end
  
  # checks to see if there is a playdate request for the current user, and if so, changes the current user's view to show a playdate request
  def playdateRequested
    p = requesting_playdate
    if p
      session[:playdate] = p.id
      playmate = User.find(p.getOtherPlayerID(current_user))
      respond_to do |format|
        format.json { render :json => {
            :playdateID => @playdate.id,
            :pusherChannelName => @playdate.pusher_channel_name,
            :initiator => playmate.username,
            :playmateID => current_user.id,
            :playmateName => current_user.username } 
          } 
        format.tablet { render :json => {
            :playdateID => @playdate.id,
            :pusherChannelName => @playdate.pusher_channel_name,
            :initiator => playmate.username,
            :playmateID => current_user.id,
            :playmateName => current_user.username }
           }
      end
    else
      respond_to do |format|
        format.json { render :json => nil } 
        format.tablet { render :json => nil }
      end  
    end  
  end
  
  # ends the current playdate session (i.e. disconnects)
  def disconnectPlaydate
    if !current_playdate.disconnected?
      Pusher[@playdate.pusher_channel_name].trigger('end_playdate', {:player => current_user.id})
      #Pusher["disconnect-channel"].trigger('playdate_disconnected', current_playdate.as_json(:user => current_user))
      current_playdate.disconnect 
    end
    session[:playdate] = nil
    render :nothing => true
  end
  
  # deprecated
  # checks to see if the playdate has ended, and if so, changes the current user's view accordingly
  def playdateDisconnected
    if Playdate.find(params[:playdate]).disconnected? #current_playdate.disconnected?
        respond_to do |format|
          format.json { render :json => true } 
          format.tablet { render :json => true }
        end
    else
      respond_to do |format|
        format.json { render :json => nil } 
        format.tablet { render :json => nil }
      end  
    end
  end
  
  # deprecated
  # deletes all playdate sessions from the db
  def clearPlaydate
    Playdate.delete_all 
    respond_to do |format|
      format.js { render :nothing => true }
    end
  end
  
  # updates the player-initiated change of the playdate state, like change book or turn page, in the db 
  def updatePlaydate
    @playdate = Playdate.find(session[:playdate])
    @playdate.change = params[:playdateChange]
    @playdate.save
    
    case @playdate.change
      when Playdate::CHANGE_BOOK
        b = getBook(params[:activityID])
        @playdate.page_num = 1
        @playdate.save
        Pusher[@playdate.pusher_channel_name].trigger('change_book', {:data => b.to_json(:include => :pages), :player => current_user.id})
        respond_to do |format|
          format.json { render :json => b.to_json(:include => :pages) } 
          format.tablet { render :json => b.to_json(:include => :pages) }
        end
      when Playdate::TURN_PAGE
        @playdate.page_num = params[:newPage]
        @playdate.save
        Pusher[@playdate.pusher_channel_name].trigger('turn_page', {:player => current_user.id, :page => params[:newPage]})
        render :nothing => true
      when Playdate::CHANGE_KEEPSAKE
        respond_to do |format|
          format.json { render :json => true }
          format.tablet { render :json => true }
        end 
      end
  end
    
  # updates the player-initiated change of the playdate state, like change book or turn page, in the db 
  # deprecated => updatePlaydate
  def updatePage
    @playdate = Playdate.find(session[:playdate])
    @playdate.change = params[:playdateChange]
    @playdate.save
    
    case @playdate.change
    when Playdate::TURN_PAGE
      @playdate.page_num = params[:newPage]
      @playdate.save
      render :nothing => true
    when Playdate::CHANGE_BOOK
      getBook(params[:book])
      @playdate.page_num = 1
      @playdate.save
    when Playdate::CHANGE_VIDEO
      render 'update_video'
    when Playdate::PLAY_VIDEO
      render :nothing => true
    when Playdate::PAUSE_VIDEO
      render :nothing => true
    when Playdate::CHANGE_KEEPSAKE
      render 'update_keepsake'
    when Playdate::TURN_KEEPSAKE
      @playdate.page_num = params[:newPage]
      @playdate.save
      render :nothing => true
    when Playdate::CHANGE_GAME
      render 'update_game'
    when Playdate::TAKE_TURN
      @playdate.page_num = params[:item]      
      @playdate.correct = params[:correct]   
      @playdate.save   
      render :nothing => true
    when Playdate::TOGGLE_VIDEO
      render :nothing => true
    when Playdate::NONE
      render :nothing => true
    end
  end
  
  # called via ajax from one of the players in the playdate b/c they got a tokbox signal from another player indicating that the play state has changed, e.g. turned page in a book. refreshes the playdate for this user with the latest play state 
  # gonna need to fix up this code: won't work with multiple changes in a row by one party...
  def updateFromPlaydate
    @playdate = current_playdate
    case @playdate.change
    when Playdate::CHANGE_BOOK
        getBook(@playdate.book_id)
        render "change_book"
    when Playdate::TURN_PAGE
        render "turn_page"
    when Playdate::CHANGE_VIDEO
      render 'change_video'
    when Playdate::PLAY_VIDEO
      render 'play_video'
    when Playdate::PAUSE_VIDEO
      render 'pause_video'
    when Playdate::CHANGE_KEEPSAKE
      render 'change_keepsake'
    when Playdate::TURN_KEEPSAKE
        render "turn_keepsake"
    when Playdate::CHANGE_GAME
      render 'change_game'
    when Playdate::TAKE_TURN
      render 'take_turn'
    when Playdate::TOGGLE_VIDEO
      render 'toggle_video'
    when Playdate::NONE
      render :nothing => true
    end
    @playdate.clearChange
  end
  
  # for use with youtube vids
  def setTime
    u = current_user
    u.video_time = params[:currentTime]
    u.save!
    render :nothing => true
  end
  
  # for use with youtube vids
  def checkTime
    p = current_playdate
    u = current_user
    @playmate = User.find_by_username(p.getOtherPlayerName(u))
    respond_to do |format|
      format.js { render 'print_time' }
    end
  end
  
  def memory
    @cardgame = Cardgame.new
    @cardgame.save
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def updateGame
  end
  
  def updateGameFromSession
  end

private
  def initOpenTok
    @api_key = "4f5e85254a3c12ae46a8fe32ba01ff8c8008e55d"
    if @@opentok.nil?
      @@opentok = OpenTok::OpenTokSDK.new 335312, @api_key
      @@opentok.api_url = 'https://staging.tokbox.com/hl'
    end
  end
  
  # sets up a new playdate session with a new opentok video session and a book to be read in the playdate. gets an opentok token for the user. currently hard-coded to use the 'little red riding hood' book.   
  def createPlaydate
    # set up the opentok video session and get a token for this user
    video_session = @@opentok.create_session '127.0.0.1'  
    tok_session_id = video_session.session_id
    @tok_token = @@opentok.generate_token :session_id => tok_session_id    

    # put the playdate in the db and its id in the session
    @playdate = Playdate.find_or_create_by_player1_id_and_player2_id_and_video_session_id(
      :player1_id => current_user.id, 
      :player2_id => params[:friend_id],
      :video_session_id => tok_session_id)
    
    session[:playdate] = @playdate.id
  end

  # adds the user to the requested playdate. gets a fresh opentok token for this user.
  def joinPlaydate
    if params[:playdate]
      @playdate = Playdate.find_by_id(params[:playdate])
    else
      @playdate = requesting_playdate
    end
    session[:playdate] = params[:playdate]
    @playdate.connected
    getBook(@playdate.book_id) if @playdate.book_id

    @tok_token = @@opentok.generate_token :session_id => @playdate.video_session_id 
  end
  
  def sendInvite
    playmate = User.find(@playdate.getOtherPlayerID(current_user))

    Pusher["presence-rendezvous-channel"].trigger('playdate_requested', {
      :playdateID => @playdate.id,
      :pusherChannelName => @playdate.pusher_channel_name,
      :initiator => current_user.username,
      :playmateID => playmate.id,
      :playmateName => playmate.username }
    )
    
    device_tokens = playmate.device_tokens
    if !device_tokens.blank?
       notification = {
         :schedule_for => [Time.now],
         :device_tokens => [device_tokens.last.token],
         :aps => {
           :alert => "PlayTell!!",
           :playdate_url => "http://playtell-staging.heroku.com/playdate?playdate="+@playdate.id.to_s,
           :initiator => current_user.username,
           :playmate => playmate.username }
       }
       logger.info "push notification send with this data: " notification
       Urbanairship.push(notification)
     end
   end

  # loads a book for a playdate.   
  def getBook(id)
    @playdate.book_id = id
    @playdate.save
    @book = Book.find(id)
  end
  
  # homepage & users -> application layout
  # playdates -> playdate layout
  # card games -> games layout (not really used right now)
  def chooseLayout 
    case action_name
    when 'index'
      'application'
    when 'memory', 'updateGame', 'updateGameFromSession'
      'games'
    else
      'playdates'
    end
  end
end
