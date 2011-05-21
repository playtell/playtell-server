class Book < ActiveRecord::Base
  has_many :pages
  has_many :playdates
end
