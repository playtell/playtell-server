class User < ActiveRecord::Base
  has_one :playdate
  
  has_many :friendships
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user
  
  attr_accessible :username, :password, :password_confirmation
  
  attr_accessor :password
  before_save :encrypt_password
  
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :username
  validates_uniqueness_of :username
  
  def self.authenticate (username, password)
    user = find_by_username(username)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
  
  def fullName
    "#{firstname} #{lastname}" 
  end
  
  def self.search(search)
    if search
      where("firstname like ? or lastname like ? or username like ?", "%#{search}%", "%#{search}%", "%#{search}%")
    else
      scoped
    end
  end
  
  def allFriends
    self.friends + self.inverse_friends
  end
  
  def allFriendships
    all_ids = []
    for f in self.friendships 
      all_ids << f.friend_id
    end
    for i in self.inverse_friendships
      all_ids << i.user_id
    end
    return all_ids
  end
  
  def isFriend? (user)
    return allFriends.index(user)
  end
  
end
