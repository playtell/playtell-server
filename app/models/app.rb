class App < ActiveRecord::Base
  has_one :book
  has_one :game
end
