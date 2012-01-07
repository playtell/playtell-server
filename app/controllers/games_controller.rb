class GamesController < ApplicationController
  before_filter :initOpenTok, :only => [:playdate]
  #before_filter :authorize
  before_filter :authenticate_user!
  layout :chooseLayout
      
  @@opentok = nil

  # main method to connect users with playdates. creates a new playdate, or adds user to existing playdate.
  def playdate
    #if (params[:connection_type] == "create")
    if !requesting_playdate
      createPlaydate
    #elsif (params[:connection_type] == "join")
    else
      joinPlaydate
    end
    @books = Book.all
    @feedback = Feedback.new
  end
  
  # checks to see if there is a playdate request for the current user, and if so, changes the current user's view to show a playdate request
  def playdateRequested
    if requesting_playdate
      session[:playdate] = @playdate.id
    end
  end
  
  # checks to see if the playdate has ended, and if so, changes the current user's view accordingly
  def playdateDisconnected
    if !Playdate.find(params[:playdate]).disconnected? #current_playdate.disconnected?
      render :nothing => true
    end
  end
    
  # updates the player-initiated change of the playdate state, like change book or turn page, in the db 
  # should be called updatePlaydate
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
    when Playdate::CHANGE_SLIDE
      render 'update_slide'
    when Playdate::TURN_SLIDE
      @playdate.page_num = params[:newPage]
      @playdate.save
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
  
  def setTime
    u = current_user
    u.video_time = params[:currentTime]
    u.save!
    render :nothing => true
  end
  
  def checkTime
    p = current_playdate
    u = current_user
    @playmate = User.find_by_username(p.getOtherPlayerName(u))
    respond_to do |format|
      format.js { render 'print_time' }
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
    when Playdate::CHANGE_SLIDE
      render 'change_slide'
    when Playdate::TURN_SLIDE
        render "turn_slide"
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
  
  # deletes all playdate sessions from the db
  def clearPlaydate
    Playdate.delete_all 
    respond_to do |format|
      format.js { render :nothing => true }
    end
  end
  
  # ends the current playdate session (i.e. disconnects)
  def disconnectPlaydate
    current_playdate.disconnect if !current_playdate.disconnected?
    session[:playdate] = nil
    render :nothing => true
#    respond_to do |format|
#      format.html { redirect_to @current_user }
#      format.js
#    end
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
      :player1_id => session[:user_id], 
      :player2_id => params[:friend_id],
      :video_session_id => tok_session_id)
    getBook(@playdate.book_id)
    
    session[:playdate] = @playdate.id
  end

  # adds the user to the requested playdate. gets a fresh opentok token for this user.
  def joinPlaydate
    @playdate = requesting_playdate
    @playdate.connected
    getBook(@playdate.book_id)

    @tok_token = @@opentok.generate_token :session_id => @playdate.video_session_id 
  end

  # loads a book for a playdate.   
  def getBook(id)
    @book = Book.find(id)
    @playdate.book_id = id
    @playdate.save
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
