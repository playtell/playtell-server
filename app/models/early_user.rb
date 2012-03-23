class EarlyUser < ActiveRecord::Base
  validates_presence_of :has_kids, :owns_iPad
  validates :email, 
            :presence => true, 
            :uniqueness => true, 
            :email_format => true  
            
  def qualifies?
    has_kids and owns_iPad
  end
  
end
