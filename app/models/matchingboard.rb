class Matchingboard < ActiveRecord::Base
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

	# turn indicators
	CREATORS_TURN = 0
	PLAYMATES_TURN = 1

	#instance variable representing card array
	@@cards

	# duplicates:
	# this game has a lot of duplicates (ex. $0.01 vs 'one cent')
	# those still have to match even though technically they have different asset ids
	DUPLICATES = [[1,2], [3,4], [5,21], [6,7], [8,9], [10,11], [12,13], [14,15], [16,17], [18,19]]

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
				# Card is already unavailable
				return false
			end
			cards[index] = CARD_UNAVAILABLE
			self.num_cards_left = (self.num_cards_left - 1)
			self.card_array_string = self.card_array_to_string(cards)
			self.save
			return true
		end
		# puts "index out of bounds!"
		return false
	end

	def init_card_array
		@@cards = Array.new(self.num_total_cards)

		#load up artwork stack
		stack_of_artwork_ids_pairing = Array.new
		stack_of_artwork_ids_available = Array.new

		(1..(self.num_total_cards / 2)).each do |i|
			stack_of_artwork_ids_pairing.push(i)
			stack_of_artwork_ids_available.push(i)
		end
		stack_of_artwork_ids_pairing = stack_of_artwork_ids_pairing.shuffle # Shuffle the numbers randomly
		stack_of_artwork_ids_available = stack_of_artwork_ids_available.shuffle # Shuffle the numbers randomly

		@@cards = stack_of_artwork_ids_pairing + stack_of_artwork_ids_available
		self.card_array_string = self.card_array_to_string(@@cards)
		self.save
	end

	def card_array_to_string(array)
		array.map {|i| i.to_s}.join(',')
	end

	#filename format is theme[theme_id]artwork[artwork_id]_l.png (or _r.png)
	def get_array_of_card_backside_filenames
		filename_array = Array.new
		themeid = Gamelet.find_by_id(self.gamelet).theme_id
		totalCardsInSet = self.num_total_cards/2

		@@cards.each_with_index do |i, index|
			leftOrRight = (index < totalCardsInSet) ? "_r" : "_l"
			filename = "theme" + themeid.to_s + "artwork" + i.to_s + leftOrRight + ".png"
			filename_array.push(filename)
		end
		return filename_array
	end

	def valid_card_at_index(index)
		cards = self.card_array_from_string(self.card_array_string)
		if self.index_in_bounds(index)
			if (cards[index].to_s != CARD_UNAVAILABLE.to_s)
				return true
			else
				return false
			end
		end
		return false
	end

	def is_a_match(a,b)
		if (self.valid_card_at_index(a) && self.valid_card_at_index(b))
			cards = self.card_array_from_string(self.card_array_string)
			if (cards[a] == cards[b])
				return true
			else
				# Check all the duplicates. If this is one of them, verify card against duplicate value
				DUPLICATES.each do |dup_arr|
					if dup_arr.include?(cards[b])
						dup_card = dup_arr.index(cards[b]) == 0 ? dup_arr[1] : dup_arr[0]
						if cards[a] == dup_card
							# Duplicate card is a match!
							return true
						else
							# Neither original nor duplicate card matched
							return false
						end
					end
				end
				# Original card didn't match and didn't find any duplicates to match against
				return false
			end
		else
			return false
		end
	end

	def we_have_a_winner
		self.num_cards_left <= 1
	end

	def card_array_from_string(mystring)
		mystring.split(',').map {|i| i.to_i}
	end

	def set_winner
		if self.initiator_score > self.playmate_score
			self.winner = initiator_id
		elsif self.playmate_score > self.initiator_score
			self.winner = playmate_id
		elsif self.initiator_score == self.playmate_score
			self.winner = -1 # draw
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