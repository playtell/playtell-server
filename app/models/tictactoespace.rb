class Tictactoespace < ActiveRecord::Base
	belongs_to :tictactoeboard
	attr_accessible :friend_id, :available, :coordinates

	def set_space(friend_id)
		self.friend_id = friend_id
		if !self.available
			return false
		end
		self.available = false
		self.save
		return true
	end

	def is_first_row #rails truncates leading zeros. for this we need special first row handling
		self.coordinates.to_i < 10
	end

	def get_x
		cor = self.coordinates.to_s()
		
		return 0 if cor.split('').map(&:to_i).first.nil? || self.is_first_row #special handling for first row
		cor.split('').map(&:to_i).first
	end

	def get_y
		cor = self.coordinates.to_s()

		return cor.split('').map(&:to_i).first if self.is_first_row #special handling for first row
		
		return 0 if cor.split('').map(&:to_i).second.nil?
		cor.split('').map(&:to_i).second
	end
end
