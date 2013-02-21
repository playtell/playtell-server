class ProfilePhoto < ActiveRecord::Base
  attr_accessible :photo, :user_id
  belongs_to :user
  
  mount_uploader :photo, PhotoUploader
end
