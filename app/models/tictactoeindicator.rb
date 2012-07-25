class Tictactoeindicator < ActiveRecord::Base
	belongs_to :tictactoeboard
	attr_accessible :x_count, :y_count, :is_a_row, :row_or_col_index

	# ---- CONSTANTS ----
	MAX_ACROSS = 3
	MAX_UP_AND_DOWN = 3

	def game_over
		self.x_count >= MAX_ACROSS || self.y_count >= MAX_UP_AND_DOWN
	end

	#increments indicator's count depending on the type of piece placed (x or y)
	def increment_count(is_x)
		if is_x
			self.x_count = self.x_count + 1
		else
			self.y_count = self.y_count + 1
		end
		self.save
	end
end
