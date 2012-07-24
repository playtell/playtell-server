class Games::Indicator < ActiveRecord::Base
	belongs_to :board
	attr_accessible :x_count, :y_count, :is_a_row, :row_or_col_index
end
