class Api::MatchingController < ApplicationController
	respond_to :json
	skip_before_filter :verify_authenticity_token
	before_filter :authenticate_user!

	# Constants
	MATCH_FOUND = 0
	MATCH_ERROR = 1
	FLIP_FIRST_CARD = 2
	MATCH_WINNER = 3

	#request params playmate_id, playdate_id, already_playing, theme_id, num_total_cards
	def new_game
		# Verify params
		return render :json => {:message => "API expects the following: playdate_id, playmate_id num_total_cards, theme_id. Optional values: already_playing, game_name. Refer to the API documentation for more info."} if params[:authentication_token].nil? || params[:playmate_id].nil? || params[:playdate_id].nil? || params[:num_total_cards].nil? || params[:theme_id].nil?

		# Figure out game name
		game_name = 'matching'
		if !params[:game_name].nil?
			game_name = params[:game_name]
		end
		
		# Find the playdate
		playdate = Playdate.find(params[:playdate_id])
		return render :json => {:message => "Playdate with id: #{params[:playdate_id]} not found."} if playdate.nil?

		# Grab the theme_id and validate it (validation is a TODO)
		theme_id = params[:theme_id].to_i

		# Create a gamelet
		gamelet = Gamelet.create(:theme_id => theme_id)

		# Verify num_total_cards
		num_total_cards = params[:num_total_cards].to_i
		num_total_cards_valid = (num_total_cards < 4) || ((num_total_cards % 2) != 0) || (num_total_cards > 12)
		return render :json => {:message => "num_total_cards needs to be between 4 and 12 and must be an even number"} if num_total_cards_valid

		# Find the game players
		initiator = current_user
		playmate = User.find(params[:playmate_id])
		return render :json => {:message => "Playmate with id: #{params[:playmate_id]} not found."} if playmate.nil?

		# Generate new matching board via Gamelet
		board_id = gamelet.new_matchinggame_board(initiator.id, playmate.id, playdate.id, num_total_cards)
		board = Matchingboard.find(board_id)

		# Collect all the filenames for this board + theme
		filename_array = board.get_array_of_card_backside_filenames
		filename_dump = JSON.dump(filename_array)

		# Notify via pusher
		if !params[:already_playing].nil?
			# If already playing, refreshing the game
			Pusher[playdate.pusher_channel_name].trigger('games_matching_refresh_game', {
				:initiator_id => initiator.id,
				:playmate_id => playmate.id,
				:board_id => board_id,
				:card_array_string => board.card_array_string,
				:filename_dump => filename_dump,
				:num_cards => num_total_cards,
				:game_name => game_name
			})
      		render :json => {
      			:message => "Matchingboard successfully refreshed, playdate id is #{playdate.id.to_s}",
      			:initiator_id => initiator.id,
				:playmate_id => playmate.id,
      			:board_id => board_id,
      			:card_array_string => board.card_array_string,
      			:filename_dump => filename_dump,
      			:num_cards => num_total_cards,
      			:game_name => game_name
      		}
      	else
      		# If not already playing, new game
      		Pusher[playdate.pusher_channel_name].trigger('games_matching_new_game', {
				:initiator_id => initiator.id,
				:playmate_id => playmate.id,
				:board_id => board_id,
				:card_array_string => board.card_array_string,
				:filename_dump => filename_dump,
				:num_cards => num_total_cards,
				:game_name => game_name
      		})
			render :json => {:card_array_string => board.card_array_string,
				:message => "Matchingboard successfully initialized, playdate id is #{playdate.id.to_s}",
				:initiator_id => initiator.id,
				:playmate_id => playmate.id,
				:board_id => board_id,
				:card_array_string => board.card_array_string,
				:filename_dump => filename_dump,
				:num_cards => num_total_cards,
				:game_name => game_name
			}
		end
	end

	#request params board_id
	def end_game
		# Verify params
		return render :json => {:message => "HTTP POST expects parameter board_id. Refer to the API documentation for more info."} if params[:board_id].nil?
	
		# Find the current game board
		board = Matchingboard.find(params[:board_id].to_i)
		return render :json => {:message => "Error: Board with that board id not found."} if board.nil?
		
		# Grab the current playdate!
		playdate = Playdate.find(board.playdate_id)
		return render :json => {:message => "Playdate with id: #{board.playdate_id} not found."} if playdate.nil?

		# End the game
		board.game_ended_by_user

		# Notify via Pusher
		Pusher[playdate.pusher_channel_name].trigger('games_matching_end_game', {
			:board_id => board.id,
			:playmate_id => current_user.id
		})

		return render :json => {:message => "Game has been terminated."}
	end

	#request params board_id, card1_index, card2_index
	def play_turn
		# Defaults
		touched_only_one_card = true
		response_code = MATCH_ERROR
		response_message = "Error: Unspecified."

		# Verify params
		return render :json=>{:message=>"API expects the following: board_id, card1_index. Optional values: card2_index. Refer to the API documentation for more info."} if params[:board_id].nil? || params[:card1_index].nil?

		# Find the game board
		board = Matchingboard.find(params[:board_id])
		return render :json => {:status => 0, :message => "Error: Board with that board id not found."} if board.nil?
		return render :json => {:status => 0, :message => "Error: Game has already ended or game is invalid"} if board.status != 0

		# Find the playdate
		playdate = Playdate.find(board.playdate_id)
		return render :json => {:message => "Playdate with id: #{board.playdate_id} not found."} if playdate.nil?
		return render :json => {:status => 0, :message => "Error: Playmate with id #{current_user.id.to_s} is not authorized to change this board"} if !board.user_authorized(current_user.id)
		return render :json => {:status => 0, :message => "Error: It is not #{current_user.username.to_s}'s turn!"} if !board.is_playmates_turn(current_user.id)

		# Verify 1st card
		card1_index = params[:card1_index].to_i
		return render :json => {:status => 0, :message => "Error: Card1Index is invalid. Please pass an int in string format e.g. \"12\""} if !board.index_in_bounds(card1_index)
		
		# Verify 2nd card
		if (!params[:card2_index].nil?)
			card2_index = params[:card2_index].to_i
			return render :json => {:status => 0, :message => "Error: Card2Index is invalid. Please pass an int in string format e.g. \"12\""} if !board.index_in_bounds(card2_index)
			touched_only_one_card = false
		end
		
		# Game logic (find matched/mismatched cards)
		if (touched_only_one_card)
			# Only one card was flipped so far
			if (board.valid_card_at_index(card1_index))
				response_code = FLIP_FIRST_CARD
				response_message = "First card flipped"
			else
				response_code = MATCH_ERROR
				response_message = "Error: improper card index"
			end
		else
			# Check if cards match
			if (board.is_a_match(card1_index, card2_index))
				response_code_card1 = board.mark_index(card1_index, current_user.id)
				response_code_card2 = board.mark_index(card2_index, current_user.id)
				if ((response_code_card1) && (response_code_card2))
					# Match found!
					response_code = MATCH_FOUND
					response_message = "Match success. Card1: #{params[:card1_index]} Card2: #{params[:card2_index]}"

					# Increment user score
					board.increment_score(current_user.id)

					# Is the game over? If not, switch turn
					if (board.we_have_a_winner)
						response_code = MATCH_WINNER
						response_message = "Match success. Game over. Card1: #{params[:card1_index]} Card2: #{params[:card2_index]}"
						board.set_winner
					else
						# Switch turn
						board.set_turn(current_user.id)
					end
				else
					# Card already matched
					response_code == MATCH_ERROR					
					response_message = "Match, but those spaces already marked."

					# Switch turn
					board.set_turn(current_user.id)
				end
			else
				# Match not found!
				response_code == MATCH_ERROR
				response_message = "Not a match."

				# Switch turn
				board.set_turn(current_user.id)
			end
		end

		# Prepare response
		response = {
			:status => response_code,
			:message => response_message,
			:board_id => board.id,
			:playmate_id => current_user.id,
			:card1_index => params[:card1_index],
			:card2_index => params[:card2_index],
			:turn => board.whose_turn,
			:initiator_score => board.initiator_score,
			:playmate_score => board.playmate_score
		}
		response[:winner_id] = board.winner if (response_code == MATCH_WINNER)

		# Pusher response
		Pusher[playdate.pusher_channel_name].trigger('games_matching_play_turn', response)

		# HTTP response
		render :json => response
	end
end