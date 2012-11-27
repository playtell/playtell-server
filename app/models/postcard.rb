class Postcard < ActiveRecord::Base
  
  attr_accessible :photo, :sender_id, :receiver_id, :viewed
  belongs_to :user, :foreign_key => "receiver_id"
  
  mount_uploader :photo, PhotoUploader

end