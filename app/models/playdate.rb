class Playdate < ActiveRecord::Base
  belongs_to :book
  belongs_to :user

# returns the playdate object if one exists for the given user
  def self.findPlaydate(user)
    Playdate.find_by_player1_id(user.id) || Playdate.find_by_player2_id(user.id)
  end
  
# returns the other player in the playdate of the given user
  def getOtherPlayerName(user)
    if user.id == player1_id
      return User.find(player2_id).username
    end
    User.find(player1_id).username
  end

end
