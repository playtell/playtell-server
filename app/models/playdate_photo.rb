class PlaydatePhoto < ActiveRecord::Base
  
  attr_accessible :photo, :user_id, :playdate_id, :count
  belongs_to :user
  
  mount_uploader :photo, PhotoUploader
  
end
