class Games::Space < ActiveRecord::Base
	belongs_to :board
	attr_accessible :friend_id, :available, :coordinates

end
