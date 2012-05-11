class DeviceToken < ActiveRecord::Base
  belongs_to :user
  after_save :confirm_user
  
  def confirm_user
    User.find(self.user_id).confirmed
  end
end
