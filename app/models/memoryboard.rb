class Memoryboard < ActiveRecord::Base
	# ---- CONSTANTS ----
	# game status
	OPEN_GAME = 0
	CLOSED_UNFINISHED = 3

	# piece placement status codes
	INVALID_MATCH = 0
	VALID_MATCH = 1
	ERROR = 2

	#card identifiers
	CARD_UNAVAILABLE = 0
	CARD_ARTWORK_1 = 1 #IMPORTANT: constants for cards 1 - 5 must remain as named as such because of random card sequence generator code
	CARD_ARTWORK_2 = 2
	CARD_ARTWORK_3 = 3
	CARD_ARTWORK_4 = 4
	CARD_ARTWORK_5 = 5

	#instance variable representing card array
	@cards
	@stack_of_artwork_ids #to randomize each time new game is started

	# ---- validations ----
	attr_accessible :status, :winner, :whose_turn, :num_cards_left, :win_code, :gamelet_id, :playdate_id, :initiator_id, :num_total_cards
	belongs_to :gamelet

	## -Start board verification methods. These are bools giving the client info about the board
		def is_playmates_turn(initiator_id)
		if self.whose_turn == CREATORS_TURN
			return initiator_id == self.created_by
		else
			return initiator_id == self.playmate
		end
	end

	def user_authorized(initiator_id)
		initiator_id == self.initiator_id || initiator_id == self.playmate_id
	end

	def no_more_cards_left
		self.num_cards_left <= 1
	end

	def index_in_bounds(index)
		(index >= 0) && (index <= (self.num_cards_left - 1)
	end

	## -Start board setters
	def game_won(user_id)
		self.status = CLOSED_WON
		self.winner = user_id
		self.save
	end

	def game_ended_by_user
		self.status = CLOSED_UNFINISHED
		self.save
	end

	def is_game_creator(user_id)
		user_id == self.initiator_id
	end

	## -Start board setters
	def set_turn(user_id)
		if is_game_creator(user_id)
			self.whose_turn = PLAYMATES_TURN
		else
			self.whose_turn = CREATORS_TURN
		end
		self.save
	end

	def mark_index(index) #marks index as unavailable
		if (@cards[index] == CARD_UNAVAILABLE)
			puts "ERROR: that index is already marked"
			return false
		end
		@cards[index] = CARD_UNAVAILABLE
		return true
	end

	def init_card_array
		@cards = Array.new(self.num_total_cards)

		#load up artwork stack
		@stack_of_artwork_ids = Array.new

		(1..(self.num_total_cards / 2)).each do |i|
			@stack_of_artwork_ids.push(i) #these correspond to the CARD_ARTWORK constants defined at the top of this file
			@stack_of_artwork_ids.push(i)
		end
		@stack_of_artwork_ids.to_a.sort {rand} #randomize array

		(0..(self.num_total_cards-1)).each do |i|
			@cards[i] = @stack_of_artwork_ids.pop
		end
	end

	def card_array_to_string
		@cards.map {|i| i.to_s}.join
	end

	


end
