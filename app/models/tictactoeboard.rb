class Tictactoeboard < ActiveRecord::Base
	# ---- CONSTANTS ----
	# game status
	OPEN_GAME = 0
	CLOSED_WON = 1
	CLOSED_CATS = 2
	CLOSED_UNFINISHED = 3

	# piece placement status codes
	NOT_PLACED = 0
	PLACED_SUCCESS = 1
	PLACED_WON = 2
	PLACED_CATS = 3

	# turn indicators
	CREATORS_TURN = 0
	PLAYMATES_TURN = 1

	#other
	MAX_PIECES_PLACED = 9
	MIN_PIECES_PLACED = 0

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

	# ---- validations ----
	attr_accessible :status, :num_pieces_placed, :winner, :whose_turn, :created_by, :playmate, :win_code
	belongs_to :gamelet
	has_many :tictactoespaces, :dependent => :destroy
	has_many :tictactoeindicators, :dependent => :destroy

	## -Start board verification methods. These are bools giving the client info about the board
	def is_playmates_turn(initiator_id)
		if self.whose_turn == CREATORS_TURN
			return initiator_id == self.created_by
		else
			return initiator_id == self.playmate
		end
	end

	def user_authorized(initiator_id)
		initiator_id == self.created_by || initiator_id == self.playmate
	end

	def is_player_x(initiator_id)
		self.created_by == initiator_id
	end

	def is_board_full
		self.num_pieces_placed >= MAX_PIECES_PLACED
	end

	def is_cats_game
		self.status == CLOSED_CATS
	end

	def are_coordinates_in_bounds(coordinates)
		space = self.get_space(coordinates)
		return !space.nil?
	end

	def is_board_accepting_placements
		self.status == OPEN_GAME && self.num_pieces_placed < MAX_PIECES_PLACED && self.num_pieces_placed >= MIN_PIECES_PLACED
	end

	def is_authorized(user_id)
		self.created_by == user_id	
	end

	def is_game_creator(initiator_id)
		initiator_id == self.created_by
	end
	## -End board verification methods

	## -Start board active-record getters.
	def get_space(coordinates)
		return self.tictactoespaces.find_by_coordinates(coordinates)
	end

	def get_row_indicator(x)
		self.tictactoeindicators.find_by_is_a_row_and_row_or_col_index(true, x)
	end

	def get_col_indicator(y)
		self.tictactoeindicators.find_by_is_a_row_and_row_or_col_index(false, y)
	end

	def get_across_indicator(space)
		if space.coordinates.to_s == "0" || space.coordinates.to_s == "22" || space.coordinates.to_s == "11"
			return self.tictactoeindicators.find_by_is_a_row_and_row_or_col_index(ACROSS_INDICATOR_IS_A_ROW, ACROSS_INDICATOR_INDEX)
		elsif space.coordinates.to_s == "2" || space.coordinates.to_s == "20"
			return self.tictactoeindicators.find_by_is_a_row_and_row_or_col_index(ACROSS_INDICATOR_2_IS_A_ROW, ACROSS_INDICATOR_2_INDEX)
		end
		return nil
	end

	def game_won(user_id)
		self.status = CLOSED_WON
		self.winner = user_id
		self.save
	end

	def game_cats_game
		self.status = CLOSED_CATS
		self.save
	end

	def game_ended_by_user
		self.status = CLOSED_UNFINISHED
		self.save
	end

	## -End board active-record getters.

	## -Start board setters
	#sets whose_turn to the id of the other player
	def set_turn(user_id)
		if is_game_creator(user_id)
			self.whose_turn = PLAYMATES_TURN
		else
			self.whose_turn = CREATORS_TURN
		end
		self.save
	end

	# main method that marks a space on the board and updates the underpinnings of the model to do so
	def mark_location(coordinates, initiator_id)
		space = self.get_space(coordinates)

		return 0 if !space.available || space.nil?

		mark_success = mark_space(space, initiator_id)
		if mark_success
			set_turn(initiator_id)
			game_won = update_indicators(space, initiator_id)
			if game_won
				self.game_won(initiator_id)
				return PLACED_WON
			elsif !game_won && !self.is_board_full
				return PLACED_SUCCESS
			elsif self.is_board_full && !game_won
				self.game_cats_game
				return PLACED_CATS
			end
		end
	end

	def mark_space(space, initiator_id)
		set_success = space.set_space(initiator_id)
		if set_success
			self.num_pieces_placed = self.num_pieces_placed + 1
			return self.save
		end
		false
	end

	def update_indicators(space, initiator_id)
		x = space.get_x
		y = space.get_y

		row_indicator = self.get_row_indicator(x)
		col_indicator = self.get_col_indicator(y)

		row_indicator.increment_count(is_player_x(initiator_id))
		col_indicator.increment_count(is_player_x(initiator_id))

		across_indicator1 = self.get_across_indicator(space)
		across_indicator1.increment_count(is_player_x(initiator_id)) if !across_indicator1.nil?

		across_indicator_2 = nil

		if (space.coordinates.to_s() == "11") # special handling is specifically built in here for the middle piece since it has two across indicators
			 across_indicator_2 = self.tictactoeindicators.find_by_is_a_row_and_row_or_col_index(ACROSS_INDICATOR_2_IS_A_ROW, ACROSS_INDICATOR_2_INDEX)
		end
		across_indicator_2.increment_count(is_player_x(initiator_id)) if !across_indicator_2.nil?
		
		across_2_game_over = false
		across_2_game_over = false
		
		across_2_game_over = across_indicator_2.game_over if !across_indicator_2.nil?
		across_1_game_over = across_indicator1.game_over if !across_indicator1.nil?

		if row_indicator.game_over
			if x == 0
				self.win_code = PLACED_WON_ROW_0
			elsif x == 1
				self.win_code = PLACED_WON_ROW_1
			elsif x == 2
				self.win_code = PLACED_WON_ROW_2
			end
		end

		if col_indicator.game_over
			if y == 0
				self.win_code = PLACED_WON_COL_0
			elsif y == 1
				self.win_code = PLACED_WON_COL_1
			elsif y == 2
				self.win_code = PLACED_WON_COL_2
			end
		end

		if across_1_game_over
			if across_indicator1.is_a_row
				self.win_code = PLACED_WON_ACROSS_TOP_LEFT
			else
				self.win_code = PLACED_WON_ACROS_BOTTON_LEFT
			end
		end

		if across_2_game_over
			if across_indicator2.is_a_row
				self.win_code = PLACED_WON_ACROSS_TOP_LEFT
			else
				self.win_code = PLACED_WON_ACROS_BOTTON_LEFT
			end
		end
		
		self.save	
		return row_indicator.game_over || col_indicator.game_over || across_1_game_over || across_2_game_over
	end
	## -End board active-record getters.

end
