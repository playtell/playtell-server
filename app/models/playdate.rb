class Playdate < ActiveRecord::Base
  belongs_to :book
  belongs_to :user
  
  after_create :setChannel
  
  DISCONNECTED=0
  CONNECTING=1
  CONNECTED=2
  
  NONE=0
  TOGGLE_VIDEO=99 #hack for our audio-only tests. hides the video windows
  CHANGE_BOOK=100
  TURN_PAGE=101

  CHANGE_VIDEO=300
  PLAY_VIDEO=301
  PAUSE_VIDEO=302

  CHANGE_KEEPSAKE=500
  TURN_KEEPSAKE=501

  CHANGE_GAME=1000
  CHANGE_GAMELET=1001
  TAKE_TURN=1002
  
  def setChannel
    self.pusher_channel_name = "private-playdate-channel-" + self.id.to_s
    save
  end
  
  def hasUser(user)
    self.player1_id == user.id || self.player2_id == user.id
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
    
    j = {:id => self.id, :otherPlayer => getOtherPlayerName(options[:user])} if options[:user]
    
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
