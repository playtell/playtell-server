class HangmanBoard < ActiveRecord::Base
	attr_accessible
		:state,
		:playdate_id,
		:initiator_id,
		:playmate_id,
		:misses,
		:whose_turn,
		:winner,
		:word,
		:word_bits

	def my_turn?(player_id)
		if self.whose_turn == Api::HangmanController::WHOSE_TURN_INITIATOR
			return player_id == self.initiator_id
		else
			return player_id == self.playmate_id
		end
	end

	def user_authorized?(player_id)
		player_id == self.initiator_id || player_id == self.playmate_id
	end
end