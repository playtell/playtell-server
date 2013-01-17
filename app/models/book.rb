class Book < ActiveRecord::Base
  has_many :pages
  has_many :playdates
  belongs_to :activity, :dependent => :destroy
  
end
