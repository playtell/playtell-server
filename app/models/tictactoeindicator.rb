class Tictactoeindicator < ActiveRecord::Base
	belongs_to :tictactoeboard
	attr_accessible :x_count, :y_count, :is_a_row, :row_or_col_index

	#increment count
	def increment_count(is_x)
		if self.is_a_row
			addition = "ROW" + self.row_or_col_index.to_s
		else
			addition = "COL" + self.row_or_col_index.to_s
		end
		if is_x
			self.x_count = self.x_count + 1
			self.save
			puts addition +" XIndicator: " + self.id.to_s() + " is now set to " + self.x_count.to_s()
			puts addition + " YIndicator: " + self.id.to_s() + " is now set to " + self.y_count.to_s()
			return self.x_count > 2
		else
			self.y_count = self.y_count + 1
			self.save
			puts addition + " XIndicator: " + self.id.to_s() + " is now set to " + self.x_count.to_s()
			puts addition + " YIndicator: " + self.id.to_s() + " is now set to " + self.y_count.to_s()
			return self.y_count > 2
		end
	end
end
