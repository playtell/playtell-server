class Api::HangmanController < ApplicationController
	respond_to :json
	skip_before_filter :verify_authenticity_token
	before_filter :authenticate_user!

	# Constants: Game state - saved in DB. Represents current game state
	STATE_WORD_PICK   = 0 # Initiator is picking a word
	STATE_LETTER_PICK = 1 # Playmate is picking a letter
	STATE_DRAW        = 2 # Initiator is drawing
	STATE_FINISHED    = 3 # Game finished by win or loss
	STATE_ENDED       = 4 # Game ended prematurely by either player

	# Constants: Turn type - passed in to turn endpoint to register the type of turn
	TURN_WORD_PICK    = 0 # Initiator has chosen a word
	TURN_LETTER_PICK  = 1 # Playmate has guessed a letter
	TURN_DRAW         = 2 # Initiator has drawn a shape
	TURN_HANG         = 3 # Initiator has chosen to hang the man

	# Constants: Whose turn
	WHOSE_TURN_INITIATOR = 0
	WHOSE_TURN_PLAYMATE  = 1

	#request params playmate_id, playdate_id, already_playing
	def new_game
		# Verify params
		return render :json => {:message => "API expects the following: playdate_id, playmate_id. Optional values: already_playing. Refer to the API documentation for more info."} if params[:playmate_id].nil? || params[:playdate_id].nil?
		
		# Find the playdate
		playdate = Playdate.find(params[:playdate_id])
		return render :json => {:message => "Playdate with id: #{params[:playdate_id]} not found."} if playdate.nil?

		# Find the game players
		initiator = current_user
		playmate = User.find(params[:playmate_id])
		return render :json => {:message => "Playmate with id: #{params[:playmate_id]} not found."} if playmate.nil?

		# Generate new hangman board via Gamelet
		board = HangmandBoard.create({
			:state        => STATE_WORD_PICK,
			:playdate_id  => playdate.id,
			:initiator_id => initiator.id,
			:playmate_id  => playmate.id,
			:misses       => 0,
			:whose_turn   => nil
		})

		# Notify via pusher
		if !params[:already_playing].nil?
			# If already playing, refreshing the game
			Pusher[playdate.pusher_channel_name].trigger('games_hangman_refresh_game', {
				:initiator_id => initiator.id,
				:playmate_id  => playmate.id,
				:board_id     => board.id
			})
      		render :json => {
      			:message      => "Hangman successfully refreshed, playdate id is #{playdate.id.to_s}",
      			:initiator_id => initiator.id,
				:playmate_id  => playmate.id,
      			:board_id     => board.id
      		}
      	else
      		# If not already playing, new game
      		Pusher[playdate.pusher_channel_name].trigger('games_hangman_new_game', {
				:initiator_id => initiator.id,
				:playmate_id  => playmate.id,
				:board_id     => board_id
      		})
			render :json => {
				:message      => "Hangman successfully initialized, playdate id is #{playdate.id.to_s}",
				:initiator_id => initiator.id,
				:playmate_id  => playmate.id,
				:board_id     => board.id
			}
		end
	end

	#request params board_id
	def end_game
		# Verify params
		return render :json => {:message => "HTTP POST expects parameter board_id. Refer to the API documentation for more info."} if params[:board_id].nil?
	
		# Find the current game board
		board = HangmandBoard.find(params[:board_id].to_i)
		return render :json => {:message => "Error: Board with that board id not found."} if board.nil?
		
		# Grab the current playdate!
		playdate = Playdate.find(board.playdate_id)
		return render :json => {:message => "Playdate with id: #{board.playdate_id} not found."} if playdate.nil?

		# End the game
		board.state = STATE_ENDED
		board.save

		# Notify via Pusher
		Pusher[playdate.pusher_channel_name].trigger('games_hangman_end_game', {
			:board_id    => board.id,
			:playmate_id => current_user.id
		})

		return render :json => {:message => "Game has been terminated."}
	end

	#request params board_id, turn_type
	def play_turn
		# Verify params
		return render :json => {:status => false, :message => "API expects the following: board_id, turn_type. Refer to the API documentation for more info."} if params[:board_id].nil? || params[:turn_type].nil?

		# Find the game board
		board = HangmandBoard.find(params[:board_id].to_i)
		return render :json => {:status => false, :message => "Error: Board with that board id not found."} if board.nil?
		return render :json => {:status => false, :message => "Error: Game has already ended or game is invalid"} if [STATE_ENDED, STATE_FINISHED].include?(board.state)

		# Find the playdate
		playdate = Playdate.find(board.playdate_id)
		return render :json => {:status => false, :message => "Playdate with id: #{board.playdate_id} not found."} if playdate.nil?
		return render :json => {:status => false, :message => "Error: Playmate with id #{current_user.id.to_s} is not authorized to change this board"} if !board.user_authorized?(current_user.id)
		return render :json => {:status => false, :message => "Error: It is not #{current_user.username.to_s}'s turn!"} if !board.my_turn?(current_user.id)

		# Take action based on turn_type
		extra_response = {}
		if turn_type == TURN_WORD_PICK
			# Verify state for this turn
			return render :json => {:status => false, :message => "Error: Invalid game state for this turn type"} if board.state != STATE_WORD_PICK

			# Verify word length
			word = params[:word].downcase
			return render :json => {:status => false, :message => "Error: Word length must be more than 2 but not greater than 6"} if (word.length < 3 || word.length > 6)

			# Save word, switch turn, advance game state
			board.word = word
			board.word_bits = word.split(//).join(',')
			board.whose_turn = WHOSE_TURN_PLAYMATE
			board.state = STATE_LETTER_PICK
			board.save

			# Response
			extra_response = {:word_length => word.length}
		elsif turn_type == TURN_LETTER_PICK
			# Verify state for this turn
			return render :json => {:status => false, :message => "Error: Invalid game state for this turn type"} if board.state != STATE_LETTER_PICK
			
			# Verify letter
			letter = params[:letter].downcase
			return render :json => {:status => false, :message => "Error: Invalid letter"} if letter.length != 1

			# See if letter is valid
			word_bits = board.word_bits.split(',')
			if word_bits.include?(letter)
				# Yes, letter guessed correctly
				word_bits.map!{|x| x == letter ? '' : x} # Removes guessed letter from array
				board.word_bits = word_bits.join(',')

				# Check if game is over
				is_game_over = (word_bits.uniq.count == 1 && word_bits.uniq.first == '')
				if is_game_over
					board.winner = WHOSE_TURN_PLAYMATE
					board.state = STATE_FINISHED
				end
				board.save

				# Response
				extra_response = {:guessed => true}
			else
				# No, letter is incorrect
				board.whose_turn = WHOSE_TURN_INITIATOR
				board.state = STATE_DRAW
				board.save

				# Response
				extra_response = {:guessed => false}
			end
		elsif turn_type == TURN_DRAW
			# Verify state for this turn
			return render :json => {:status => false, :message => "Error: Invalid game state for this turn type"} if board.state != STATE_DRAW

			# TODO: Save drawing

			# Update board
			board.whose_turn = WHOSE_TURN_PLAYMATE
			board.state = STATE_LETTER_PICK
			board.save
		elsif turn_type == TURN_HANG
			# Verify state for this turn
			return render :json => {:status => false, :message => "Error: Invalid game state for this turn type"} if board.state != STATE_DRAW

			# Update board
			board.winner = WHOSE_TURN_INITIATOR
			board.state = STATE_FINISHED
			board.save
		end

		# Prepare response
		response = {
			:board_id     => board.id,
			:playdate_id  => playdate.id,
			:initiator_id => board.initiator_id,
			:playmate_id  => board.playmate_id,
			:state        => board.state,
			:whose_turn   => board.whose_turn,
			:winner       => board.winner
		}
		response.merge!(extra_response)

		# Send response via Pusher and HTTP
		Pusher[playdate.pusher_channel_name].trigger('games_hangman_play_turn', response)
		render :json => response
	end
end