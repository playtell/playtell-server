class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => "User"
  
  def self.exists(id1, id2)
    Friendship.find_by_user_id_and_friend_id(id1, id2) || Friendship.find_by_user_id_and_friend_id(id2, id1)
  end
end
