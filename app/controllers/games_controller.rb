class GamesController < ApplicationController
  before_filter :initOpenTok, :only => [:playdate]
  before_filter :authorize
  
  @@opentok = nil
    
  def index  
  end

  # main method to connect users with playdates. creates a new playdate, or adds user to existing playdate.
  def playdate
    if (params[:connection_type] == "create")
      createPlaydate
    elsif (params[:connection_type] == "join")
      joinPlaydate
    end
    
    respond_to do |format|
      format.html { render("ragatzi.html")}
    end
  end
    
  # changes the currently displayed book page stored in the playdate session
  def updatePage
    @playdate = Playdate.find(session[:playdate])
    @playdate.page_num = params[:newPage]
    @playdate.save
    respond_to do |format|
      format.js { render :nothing => true }
    end
  end
  
  # loads the updated playdate from the session. called via ajax from one of the players in the playdate b/c they got a tokbox signal from another player.
  def updatePlaydate
    @playdate = Playdate.find(session[:playdate])
    respond_to do |format|
      format.js { render 'update_page' }
    end
  end
  
  # clears all playdate sessions in the db
  def clearPlaydate
    Playdate.delete_all 
    respond_to do |format|
      format.js { render :nothing => true }
    end
  end
  
  # deletes the current playdate session
  def deletePlaydate
    Playdate.delete(session[:playdate])
    respond_to do |format|
      format.html { redirect_to :root }
    end
  end

protected
  def initOpenTok
    @api_key = "4f5e85254a3c12ae46a8fe32ba01ff8c8008e55d"
    if @@opentok.nil?
      @@opentok = OpenTok::OpenTokSDK.new 335312, @api_key
      @@opentok.api_url = 'https://staging.tokbox.com/hl'
    end
  end
  
  def authorize
    unless current_user
      flash.now.alert = "Please log in"
      redirect_to login_path
    end
  end
  
  # sets up a new playdate session with a new opentok video session and a book to be read in the playdate. gets an opentok token for the user. currently hard-coded to use the 'semira' user and 'little red riding hood' book.   
  def createPlaydate
    player1 = User.find(session[:user_id])
    player2 = User.find_by_username("aydin")
    getBook(Book.find_by_title("Little Red Riding Hood"))

    # set up the opentok video session and get a token for this user
    video_session = @@opentok.create_session '127.0.0.1'  
    tok_session_id = video_session.session_id
    @tok_token = @@opentok.generate_token :session_id => tok_session_id    

    # put the playdate in the db and its id in the session
    @playdate = Playdate.create(
      :player1_id => player1.id, 
      :player2_id => player2.id, 
      :book_id => @book.id, 
      :page_num => 1, 
      :video_session_id => tok_session_id)
    session[:playdate] = @playdate.id
  end

  # adds the user to the existing session (right now assumes only one session ever exists). currently hard-coded to use the 'aydin' user. gets an opentok token for the newly-added user.
  def joinPlaydate
    @playdate = Playdate.find_by_player1_id(User.find_by_username("shirin"))
    session[:playdate] = @playdate.id
    getBook(@playdate.book_id)

    @tok_token = @@opentok.generate_token :session_id => @playdate.video_session_id 
  end

  # loads a book for a playdate.   
  def getBook(id)
    @book = Book.find(id)
  end
end
