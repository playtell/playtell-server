class Playdate < ActiveRecord::Base
  belongs_to :book
  belongs_to :user
  
  after_create :initBook
  
  DISCONNECTED=0
  CONNECTING=1
  CONNECTED=2
  
  NONE=0
  CHANGE_BOOK=100
  TURN_PAGE=101
  #CHANGE_GAME=200 in the future maybe make this an array so all activity within a playdate can be tracked
  
  def initBook 
    self.book_id = Book.find_by_title("Little Red Riding Hood").id
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
      return User.find(player2_id).username
    end
    User.find(player1_id).username
  end

#getter/setter methods for playdate status  
  def disconnect
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
