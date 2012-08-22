class Game < ActiveRecord::Base
  belongs_to :app
  
  before_create :create_app
  
  # creates the corresponding app record in the db for this game
  def create_app
    a = App.new()
    a.save
    self.app_id = a.id
  end
end