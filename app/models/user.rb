class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable
           #:confirmable, :lockable, :timeoutable
  
  attr_accessible :username, :password, :password_confirmation, :email, :firstname, :lastname, :authentication_token  
  
  after_create :create_profile_photo
  before_save :ensure_authentication_token! 
  
  has_one :playdate  
  has_many :friendships
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user
  has_many :device_tokens
  has_many :playdate_photos
  
  def ensure_authentication_token!   
      reset_authentication_token! if authentication_token.blank?   
    end
    
  def create_profile_photo
    randomPhotoIndex = 1 + rand(4)
    
    p = self.playdate_photos.create
    p.remote_photo_url = 'http://ragatzi.s3.amazonaws.com/uploads/profile_default_' + randomPhotoIndex.to_s + '.png'
    p.save!
  end
  
  def profile_photo
    photos = self.playdate_photos
    photos.empty? ? nil : photos.last.photo.url 
  end

  def fullName
    "#{firstname} #{lastname}" 
  end
  
  def displayName
    return !firstname.blank? ? firstname : username 
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
