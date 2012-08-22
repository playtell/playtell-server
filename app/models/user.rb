class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable
           #:confirmable, :lockable, :timeoutable
  
  attr_accessible :username, :password, :password_confirmation, :email, :firstname, :lastname, :authentication_token, :status 
  
  before_create :set_defaults
  after_create :create_profile_photo, :add_first_friend
  before_save :ensure_authentication_token!, :update_status
  
  has_one :playdate  
  has_many :friendships
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user
  has_many :device_tokens
  has_many :playdate_photos
  has_many :contacts
  has_many :contact_notifications

  #status
  WAITING_FOR_UDID = -2
  WAITING_FOR_DOWNLOAD = -1
  CONFIRMED = 0
  #DONE_FIRST_PLAYDATE
  #DONE_SECOND_PLAYDATE

  def set_defaults
    self.status = WAITING_FOR_DOWNLOAD if self.status.blank?
  end

  # auto-adds Test as this user's first friend
  def add_first_friend
    if User.count > 0
      self.friendships.create!(:friend_id => User.find_by_username(DEFAULT_FRIEND_NAME).id)
    end
  end
  
  # assigns one of the default balloon photos to the user as their first profile photo  
  def create_profile_photo
    randomPhotoIndex = 1 + rand(10)
    p = self.playdate_photos.create
    p.remote_photo_url = 'http://ragatzi.s3.amazonaws.com/uploads/profile_default_' + randomPhotoIndex.to_s + '.png'
    p.save!    
  end
  
  # uses the most recently taken photo as this user's profile photo
  def profile_photo
    photos = self.playdate_photos
    photos.empty? ? nil : photos.first.photo.url 
  end

  def fullName
    "#{firstname} #{lastname}" 
  end
  
  def displayName
    username or firstname 
  end
  
  #searches users whose name matches the search parameter 
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

  def allApprovedFriends
    self.friends.where("friendships.status = true") + self.inverse_friends.where("friendships.status = true")
  end
  
  def allActiveFriendships
    self.friendships.where("status != false") + self.inverse_friendships.where("status != false")
  end
  
  def isFriend? (user)
    return allFriends.index(user)
  end
  
  #getter for whether status is confirmed
  def confirmed?
    self.status >= 0
  end
  
  def confirmed
    self.status = CONFIRMED
    save!
  end

  def waiting_for_udid
    self.status = WAITING_FOR_UDID
    save!
  end

  def waiting_for_download
    self.status = WAITING_FOR_DOWNLOAD
    save!
  end
  
  def update_status
    unless self.status.blank? or self.confirmed?
      self.waiting_for_download if self.udid_changed?
    end
  end
  
  # used for token authentication, for the apis. assigns the user a token that the api can use to auth, rather than having the user sign in
  def ensure_authentication_token!   
      reset_authentication_token! if authentication_token.blank?   
    end
  
  #overriding to add the display name and profile pic
  def as_json(options={})
    u = {
      :id => self.id, 
      :email => self.email,
      :displayName => self.displayName,
      :fullName => self.fullName,
      :profilePhoto => self.profile_photo }      
  end
  
end
