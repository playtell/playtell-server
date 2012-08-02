class Game < ActiveRecord::Base
	attr_accessible :type, :playdate_id
	has_many :tictactoes # TODO remove this once confirmed that table has been renamed
	has_many :tictactoe_games

	# TODO figure out the best way to initialize tictactoe
	def create_tictactoe
		

	end
end