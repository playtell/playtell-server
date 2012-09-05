class Book < ActiveRecord::Base
  has_many :pages
  has_many :playdates
  belongs_to :app
  
  before_create :create_app
  
  # creates the corresponding app record in the db for this book
  def create_app
    a = App.new({:title => self.title})
    a.save
    self.app_id = a.id
  end
  
end
