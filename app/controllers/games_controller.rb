class GamesController < ApplicationController
  before_filter :initOpenTok, :only => [:playdate]
  before_filter :authorize
  layout :chooseLayout
      
  @@opentok = nil
  
  def earlyAccess
    File.open("early_access.txt", 'a+') { |f| f.write(params[:email]) }
  end

  # main method to connect users with playdates. creates a new playdate, or adds user to existing playdate.
  def playdate
    if (params[:connection_type] == "create")
      createPlaydate
    elsif (params[:connection_type] == "join")
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
    when Playdate::NONE
      render :nothing => true
    end
  end
  
  # refreshes the playdate with the latest play state e.g. turned page in a book. called via ajax from one of the players in the playdate b/c they got a tokbox signal from another player.
  def updateFromPlaydate
    @playdate = current_playdate
    case @playdate.change
    when Playdate::TURN_PAGE
      render "turn_page"
    when Playdate::CHANGE_BOOK
      getBook(@playdate.book_id)
      render "change_book"
    end
    @playdate.clearChange
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
    @playdate = Playdate.find(params[:playdate_id])
    @playdate.connected
    getBook(@playdate.book_id)

    @tok_token = @@opentok.generate_token :session_id => @playdate.video_session_id 
  end

  # loads a book for a playdate.   
  def getBook(id)
    @book = Book.find(id)
    @playdate.book_id = id
    @playdate.page_num = 1
    @playdate.save
  end
  
  # uses the application layout for homepage and games layout for all other pages
  def chooseLayout 
    case action_name
    when 'index'
      'application'
    else
      'games'
    end
  end
end
