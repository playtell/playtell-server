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

	# turn indicators
	CREATORS_TURN = 0
	PLAYMATES_TURN = 1

	#instance variable representing card array
	@@cards

	# ---- validations ----
	attr_accessible :initiator_score, :playmate_score, :status, :card_array_string, :winner, :whose_turn, :num_cards_left, :win_code, :gamelet_id, :playmate_id, :playdate_id, :initiator_id, :num_total_cards
	belongs_to :gamelet

	## -Start board verification methods. These are bools giving the client info about the board
	def is_playmates_turn(initiator_id)
		if self.whose_turn == CREATORS_TURN
			return initiator_id == self.initiator_id
		else
			return initiator_id == self.playmate_id
		end
	end

	def user_authorized(initiator_id)
		initiator_id == self.initiator_id || initiator_id == self.playmate_id
	end

	def no_more_cards_left
		self.num_cards_left <= 1
	end

	def index_in_bounds(index)
		(index >= 0) && (index <= (self.num_total_cards - 1))
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
	#sets whose_turn to the id of the other player
	def set_turn(user_id)
		if is_game_creator(user_id)
			self.whose_turn = PLAYMATES_TURN
		else
			self.whose_turn = CREATORS_TURN
		end
		self.save
	end

	def mark_index(index, initiator_id) #marks index as unavailable
		cards = self.card_array_from_string(self.card_array_string)
		if self.index_in_bounds(index)
			if (cards[index] == CARD_UNAVAILABLE)
				puts "ERROR: index " + index.to_s + " is already marked"
				return false
			end
			cards[index] = CARD_UNAVAILABLE
			self.num_cards_left = (self.num_cards_left - 1)
			self.card_array_string = self.card_array_to_string(cards)
			self.save
			puts "card array string: " + self.card_array_string
			return true
		end
		puts "index out of bounds!"
		return false
	end

	def init_card_array
		@@cards = Array.new(self.num_total_cards)

		#load up artwork stack
		stack_of_artwork_ids = Array.new

		(1..(self.num_total_cards / 2)).each do |i|
			stack_of_artwork_ids.push(i) #these correspond to the CARD_ARTWORK constants defined at the top of this file
			stack_of_artwork_ids.push(i)
		end
		stack_of_artwork_ids = stack_of_artwork_ids.shuffle #randomize array

		@@cards = stack_of_artwork_ids
		self.card_array_string = self.card_array_to_string(@@cards)
		self.save
	end

	def card_array_to_string(array)
		array.map {|i| i.to_s}.join
	end

	#filename format is theme[theme_id]artwork[artwork_id].png
	def get_array_of_card_backside_filenames
		filename_array = Array.new
		themeid = Gamelet.find_by_id(self.gamelet).theme_id

		@@cards.each do |i|
			filename = "theme" + themeid.to_s + "artwork" + i.to_s + ".png"
			filename_array.push(filename)
		end
		return filename_array
	end

	def valid_card_at_index(index)
		cards = self.card_array_from_string(self.card_array_string)
		if self.index_in_bounds(index)

			if (cards[index].to_s != CARD_UNAVAILABLE.to_s)
				puts "card still on board"
				return true
			else
				puts "Error: card NOT on board"
				return false
			end
		end
		return false
		puts "Error: index NOT on board"
	end

	def is_a_match(a,b)
		if (self.valid_card_at_index(a) && self.valid_card_at_index(b))
			cards = self.card_array_from_string(self.card_array_string)
			if (cards[a] == cards[b])
				puts "is_a_match found IT IS A MATCH"
				return true
			else
				puts "is_a_match found IT IS NOT a MATCH"
				return false
			end
		else
			puts "is_a_match found that one index is not valid"
			return false
		end
	end

	def we_have_a_winner
		self.num_cards_left <= 1
	end

	def card_array_from_string(mystring)
		mystring.split(//).map {|i| i.to_i}
	end

	def set_winner
		if self.initiator_score > self.playmate_score
			self.winner = initiator_id
		else
			self.winner = playmate_id
		end
		self.save
	end

	def increment_score(user_id)
		if user_id == self.initiator_id
			self.initiator_score = self.initiator_score + 1
		elsif user_id == self.playmate_id
			self.playmate_score = self.playmate_score + 1
		end
		self.save
	end

end
