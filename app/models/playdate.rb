class Playdate < ActiveRecord::Base
  belongs_to :book
  belongs_to :user
  
  after_create :initBook
  
  DISCONNECTED=0
  CONNECTING=1
  CONNECTED=2
  
  NONE=0
  TOGGLE_VIDEO=99 #hack for our audio-only tests. hides the video windows
  CHANGE_BOOK=100
  TURN_PAGE=101
  #CHANGE_GAME=200 
  CHANGE_VIDEO=300
  PLAY_VIDEO=301
  PAUSE_VIDEO=302
  CHANGE_SLIDE=400
  TURN_SLIDE=401
  CHANGE_KEEPSAKE=500
  TURN_KEEPSAKE=501
  CHANGE_GAME=1000
  CHANGE_GAMELET=1001
  TAKE_TURN=1002
  
  def initBook 
    self.book_id = Book.find_by_title("Little Red Riding Hood").id
    self.page_num = 1
    save
  end
  
# returns the playdate object if a non-disconnected playdate exists for the given user
  def self.findActivePlaydate(user)
    p = Playdate.where("player1_id = ? AND status != 0 OR player2_id = ? AND status != 0", user.id, user.id)
    return p.first unless p.nil?
  end
  
# returns the other player in the playdate of the given user
  def getOtherPlayerName(user)
    if user.id == player1_id
      return User.find(player2_id).displayName
    end
    User.find(player1_id).displayName
  end
  
  #overriding to add the other player's name to the json payload if needed
  def as_json(options = {})
    j = super
    
    j = j.merge({otherPlayer: getOtherPlayerName(options[:user])}) if options[:user]
    
    j
  end

#getter/setter methods for playdate status  
  def disconnect
    self.duration = (Time.now.utc.to_i - self.created_at.to_i)/60.0
    self.status = DISCONNECTED
    save
  end
  
  def disconnected?
    return self.status == DISCONNECTED
  end
  
  def connected
    self.status = CONNECTED
    save
  end
  
  def connected?
    return self.status == CONNECTED
  end
  
  def connecting
    self.status = CONNECTING
    save
  end
  
  def connecting?
    return self.status == CONNECTING
  end
  
  def clearChange
    self.change = NONE
    save
  end

end
