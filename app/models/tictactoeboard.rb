class Tictactoeboard < ActiveRecord::Base
	attr_accessible :status, :num_pieces_placed, :winner, :whose_turn, :created_by, :playmate # assume created_by is always x
	belongs_to :tictactoe  # TODO remove this once confirmed that table has been renamed
	has_many :tictactoespaces, :dependent => :destroy
	has_many :tictactoeindicators, :dependent => :destroy

	def user_authorized(friend_id)
		return friend_id == self.created_by || friend_id == self.playmate
	end

	def player_is_x(friend_id)
		return self.created_by == friend_id
	end

	def get_row_indicator(space)
		return self.tictactoeindicators.where(:is_a_row => true, :row_or_col_index => space.get_x).first
	end

	def get_col_indicator(space)
		return self.tictactoeindicators.where(:is_a_row => false, :row_or_col_index => space.get_y).first
	end

	def get_across_indicator(space)
		if space.coordinates.to_s == "0" || space.coordinates.to_s == "22" || space.coordinates.to_s == "11"
			return self.tictactoeindicators.where(:is_a_row => true, :row_or_col_index => 4).first
		elsif space.coordinates.to_s == "2" || space.coordinates.to_s == "20"
			return self.tictactoeindicators.where(:is_a_row => false, :row_or_col_index => 4).first
		end
		return nil
	end

	def space_from_coordinates(coordinates)
		return self.tictactoespaces.where(:coordinates => coordinates).first
	end

	def mark_location(coordinates, friend_id)
		space = self.space_from_coordinates(coordinates)
		puts "space is " + space.id.to_s()

		return 0 if !space.available || space.nil?

		board_full = mark_space(space, friend_id)
		game_won = update_indicators(space, friend_id)
		if board_full && !game_won
			self.game_cats_game
			return 3 #cat's game
		elsif game_won
			self.game_won(friend_id)
			return 2 #we have a winner
		elsif !game_won && !board_full #successfully placed
			return 1
		end
	end

	#returning true means that game has been won!
	def update_indicators(space, friend_id)
		#grab x and y direction indicators
		puts " Player: " + friend_id.to_s() + " is  " + player_is_x(friend_id).to_s()
		game_over_row = get_row_indicator(space).increment_count(player_is_x(friend_id))
		game_over_col = get_col_indicator(space).increment_count(player_is_x(friend_id))

		across_indicator1 = get_across_indicator(space)
		game_over_across = across_indicator1.increment_count(player_is_x(friend_id)) if !across_indicator1.nil?
		across_indicator_2 = nil
		if (space.coordinates.to_s() == "11")
			 across_indicator_2 = self.tictactoeindicators.where(:is_a_row => false, :row_or_col_index => 4).first
		end
		game_over_across_2 = across_indicator_2.increment_count(player_is_x(friend_id)) if !across_indicator_2.nil?


		return game_over_row || game_over_col || game_over_across || game_over_across_2
	end

	def mark_space(space, friend_id)
		#mark the space
		space.set_space(friend_id)
		puts "space with id: " + space.id.to_s() + " is now marked as " + space.available.to_s()
		self.num_pieces_placed = self.num_pieces_placed + 1
		self.save
		return self.num_pieces_placed > 8
	end

	# TODO a bit more error checking
	def coordinates_in_bounds(coordinates)
		#check if valid coordinate
		space = self.space_from_coordinates(coordinates)
		return !space.nil?
	end

	# boolean returning method that indicates whether game is still going on
	def accepting_placements
		return self.status == 0 && self.num_pieces_placed < 10 && self.num_pieces_placed >= 0
	end

	#returns true if passed in user can make changes to given board
	def is_authorized(user_id)
		return self.created_by == user_id	
	end

	def game_won(user_id) # TODO make sure user_id is passed as a string
		self.status = 1
		self.winner = user_id
		self.save
		#sets the winner_id and the game flag
	end

	def game_cats_game
		#sets the game flag
		self.status = 2
		self.save
	end

	def is_cats_game
		return self.status == 2
	end
end
