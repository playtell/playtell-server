class Tictactoespace < ActiveRecord::Base
	belongs_to :tictactoeboard
	attr_accessible :friend_id, :available, :coordinates

	def set_space(friend_id)
		self.friend_id = friend_id
		self.available = false
		self.save
	end

	# special handling for preceeding 0 if in first row
	def is_first_row
		return self.coordinates.to_i < 10
	end

	def get_x
		cor = self.coordinates.to_s()
		x = cor.split('').map(&:to_i).first
		return 0 if x.nil? || self.is_first_row #special handling for first row because of rails truncation
		return x
	end

	def get_y
		cor = self.coordinates.to_s()

		return cor.split('').map(&:to_i).first if self.is_first_row #special handling for first row because of rails truncation
		
		return 0 if y.nil?
		cor.split('').map(&:to_i).second
	end
end
