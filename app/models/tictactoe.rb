class Tictactoe < ActiveRecord::Base
	attr_accessible :num_boards, :num_active_games
	belongs_to :game
	has_many :tictactoeboards, :dependent => :destroy # TODO ask someone about a good way to keep track of the number of boards once they are created
	has_many :tictactoeindicators, :through => :tictactoeboards
	has_many :tictactoespaces, :through => :tictactoeboards

	# initializes and creates new board, returns -1 if fail, else returns new board id
	def create_new_board(created_by, friend_2)

		#verify that created_by exists in the users table
		creator = User.find_by_id(created_by)
		playmate = User.find_by_id(friend_2)
		return -1 if creator.nil? || playmate.nil?

		board = Tictactoeboard.create(:status => "0", :num_pieces_placed => 0, :winner => nil, :created_by => creator.id, :playmate => playmate.id)

		#create all spaces/indicators and init them
		for i in 0..2
			newRowIndicator = Tictactoeindicator.create(:x_count => 0, :y_count => 0, :is_a_row => true, :row_or_col_index => i)
			newColIndicator = Tictactoeindicator.create(:x_count => 0, :y_count => 0, :is_a_row => false, :row_or_col_index => i)
			
			board.tictactoeindicators << newRowIndicator
			board.tictactoeindicators << newColIndicator
		  for j in 0..2
		  	coordinate_int = i.to_s() + j.to_s()
		  	coordinate_int = Integer(coordinate_int)
		    newSpace = Tictactoespace.create(:coordinates => coordinate_int, :available => true)
		    board.tictactoespaces << newSpace
		  end
		end

		#create across indicators
		newAcrossIndicator = Tictactoeindicator.create(:x_count => 0, :y_count => 0, :is_a_row => true, :row_or_col_index => 4)
		newAcrossIndicator2 = Tictactoeindicator.create(:x_count => 0, :y_count => 0, :is_a_row => false, :row_or_col_index => 4)
		board.tictactoeindicators << newAcrossIndicator
		board.tictactoeindicators << newAcrossIndicator2

		return board.id
	end

	# TODO decide if we want to pass board information via json
	# returns string representation of a tic tac toe board
	def spaces_to_json
	end

end