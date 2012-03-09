class PlaydatePhoto < ActiveRecord::Base
  
  attr_accessible :photo
  belongs_to :user
  
  mount_uploader :photo, PhotoUploader
  
end
