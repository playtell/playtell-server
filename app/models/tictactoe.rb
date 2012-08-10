class Tictactoe < ActiveRecord::Base
	# ---- CONSTANTS ----
	# game status
	OPEN_GAME = 0
	CLOSED_WON = 1
	CLOSED_CATS = 2
	# turn indicators
	CREATORS_TURN = 0
	PLAYMATES_TURN = 1

	ACROSS_INDICATOR_INDEX = 4
	ACROSS_INDICATOR_IS_A_ROW = true
	
	ACROSS_INDICATOR_2_INDEX = 4
	ACROSS_INDICATOR_2_IS_A_ROW = false

	#win status codes
	PLACED_WON_COL_0 = 6
	PLACED_WON_COL_1 = 7
	PLACED_WON_COL_2 = 8
	PLACED_WON_ACROSS_TOP_LEFT = 9
	PLACED_WON_ACROS_BOTTON_LEFT = 10
	PLACED_WON_ROW_0 = 11
	PLACED_WON_ROW_1 = 12
	PLACED_WON_ROW_2 = 13
	NIL_OR_ERROR = 99

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

		board = Tictactoeboard.create(:win_code => NIL_OR_ERROR, :status => OPEN_GAME, :num_pieces_placed => 0, :winner => nil, :created_by => creator.id, :playmate => playmate.id, :whose_turn => CREATORS_TURN) # it's the creator's turn first

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
		newAcrossIndicator = Tictactoeindicator.create(:x_count => 0, :y_count => 0, :is_a_row => ACROSS_INDICATOR_IS_A_ROW, :row_or_col_index => ACROSS_INDICATOR_INDEX)
		newAcrossIndicator2 = Tictactoeindicator.create(:x_count => 0, :y_count => 0, :is_a_row => ACROSS_INDICATOR_2_IS_A_ROW, :row_or_col_index => ACROSS_INDICATOR_2_INDEX)
		board.tictactoeindicators << newAcrossIndicator
		board.tictactoeindicators << newAcrossIndicator2

		return board.id
	end

end