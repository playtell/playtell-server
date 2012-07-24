class Games::Board < ActiveRecord::Base
	attr_accessible :status, :num_pieces_placed, :winner, :whose_turn

	belongs_to :tictactoe_game
	belongs_to :tictactoe # TODO remove this once confirmed that table has been renamed

	has_many :tictactoespaces
	has_many :tictactoeindicators
end
