class Book < ActiveRecord::Base
  has_many :pages
  has_many :playdates
  belongs_to :activity
  
  before_create :create_activity
  
  # creates the corresponding app record in the db for this book
  def create_activity
    a = Activity.new({:title => self.title})
    a.save
    self.activity_id = a.id
  end
  
end
