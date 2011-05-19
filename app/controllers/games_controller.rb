class GamesController < ApplicationController
  before_filter :initOpenTok, :only => [:playdate]
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
    @playdate = session[:playdate]
    @playdate.page_num = params[:newPage]
    respond_to do |format|
      format.js { render :nothing => true }
    end
  end
  
  # loads the updated playdate from the session. called via ajax from one of the players in the playdate b/c they got a tokbox signal from another player.
  def updatePlaydate
    @playdate = session[:playdate]
    respond_to do |format|
      format.js { render 'update_page' }
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
  
  # sets up a new playdate session with a new opentok video session and a book to be read in the playdate. gets an opentok token for the user. currently hard-coded to use the 'semira' user and 'little red riding hood' book.   
  def createPlaydate
    player = User.find_by_username("semira")
    getBook("Little Red Riding Hood")

    # set up the opentok video session and get a token for this user
    video_session = @@opentok.create_session '127.0.0.1'  
    tok_session_id = video_session.session_id
    @tok_token = @@opentok.generate_token :session_id => tok_session_id    

    # put the playdate in the session
    @playdate = Playdate.new(player.id, tok_session_id)
    @playdate.setActivity(@book.title)
    session[:playdate] = @playdate
  end

  # adds the user to the existing session (right now assumes only one session ever exists). currently hard-coded to use the 'aydin' user. gets an opentok token for the newly-added user.
  def joinPlaydate
    player = User.find_by_username("aydin")
    @playdate = session[:playdate]
    @playdate.join(player.id)
    getBook(@playdate.title)

    @tok_token = @@opentok.generate_token :session_id => @playdate.video_session_id 
  end

  # loads a book for a playdate.   
  def getBook(title)
    @book = Book.where(:title => title).first
  end
end
