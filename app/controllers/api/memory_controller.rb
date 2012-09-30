class Api::MemoryController < ApplicationController
	# ---- CONSTANTS ----
	 respond_to :json
	 skip_before_filter :verify_authenticity_token
	 before_filter :authenticate_user!

	 MATCH_FOUND = 0
	 MATCH_ERROR = 1
	 FLIP_FIRST_CARD = 2
	 MATCH_WINNER = 3

	#request params initiator_id, playmate_id, authentication_token, playdate_id, already_playing, theme_id, num_total_cards
	def new_game
		return render :json=>{:message=>"API expects the following: playmate_id, playdate_id, initiator_id, num_total_cards, authentication_token, and theme_id. already_playing is optional. Refer to the API documentation for more info."} if params[:authentication_token].nil? || params[:playmate_id].nil? || params[:playdate_id].nil? || params[:initiator_id].nil? || params[:num_total_cards].nil? || params[:theme_id].nil?
		
		# grab the current playdate! 
		@playdate = Playdate.find_by_id(params[:playdate_id])
		return render :json=>{:message=>"Playdate with id: " + params[:playdate_id] + " not found."} if @playdate.nil?

		# grab the theme_id and validate it 
		## TODO at some point we need a theme table so we can error check theme_id... maybe add a "Theme" model to the rails app?
		theme_id = params[:theme_id]

		# create a new gamelet
		gamelet = Gamelet.create(:theme_id => theme_id)

		#verify num_total_cards is valid
		num_total_cards = params[:num_total_cards].to_i
		return render :json=>{:message=>"num_total_cards needs to be between 4 and 20 and must be an even number"} if (num_total_cards < 4) || ((num_total_cards % 2) != 0) || (num_total_cards > 12)

		## get playmate and intiator
		playmate = User.find_by_id(params[:playmate_id].to_i)
		initiator = User.find_by_id(params[:initiator_id].to_i)

		return render :json=>{:message=>"Initiator playmate with id: " + params[:initiator_id] + " not found."} if initiator.nil?
		return render :json=>{:message=>"Playmate with id: " + params[:playmate_id] + " not found."} if playmate.nil?

		board_id = gamelet.new_memorygame_board(initiator.id, playmate.id, num_total_cards)

		board = Memoryboard.find_by_id(board_id)

		filename_array = board.get_array_of_card_backside_filenames
		filename_dump = JSON.dump filename_array

		if !params[:already_playing].nil?
			Pusher[@playdate.pusher_channel_name].trigger('games_memory_refresh_game', {:card_array_string => board.card_array_string, :filename_dump => filename_dump, :initiator_id => initiator.id, :board_id => board_id})
      		render :json=>{:card_array_string => board.card_array_string, :message=>"Memoryboard successfully refreshed, playdate id is " + @playdate.id.to_s, :initiator_id => initiator.id, :board_id => board_id, :filename_dump => filename_dump, :num_cards => num_total_cards}
      	else
      		Pusher[@playdate.pusher_channel_name].trigger('games_memory_new_game', {:card_array_string => board.card_array_string, :filename_dump => filename_dump, :initiator_id => initiator.id, :board_id => board_id})
			render :json=>{:card_array_string => board.card_array_string, :message=>"Memoryboard successfully initialized, playdate id is " + @playdate.id.to_s, :filename_dump => filename_dump, :initiator_id => initiator.id, :board_id => board_id, :num_cards => num_total_cards}
		end

	end

	#request params card1_index, card2_index, board_id, playdate_id, authentication_token, user_id
	def play_turn
		touched_only_one_card = true

		##start PARAM validation start
		return render :json=>{:message=>"API expects the following: board_id, playdate_id, authentication_token, card1_index, card2_index, and user_id. Refer to the API documentation for more info."} if params[:user_id].nil? || params[:board_id].nil? || params[:card1_index].nil?  || params[:playdate_id].nil? || params[:authentication_token].nil?
		current_user = User.find_by_id(params[:user_id])
		return render :json=>{:message=>"Playmate cannot be found."} if current_user.nil?
		#set json response (yes send json w/ response or no)
		json_response = false
		if !params[:with_json].nil?
			json_response = true if params[:with_json] == "true"
		end
		@playdate = Playdate.find_by_id(params[:playdate_id])
		board = Memoryboard.find_by_id(params[:board_id].to_i)
		return render :json=>{:placement_status => 0, :message=>"Error: Game has already ended or game is invalid"} if board.status != 0
		return render :json=>{:message=>"Playdate with id: " + params[:playdate_id] + " not found."} if @playdate.nil?
		return render :json=>{:placement_status => 0, :message=>"Error: Playmate cannot be found."} if current_user.nil? #TODO figure out why json status messages don't work in browser
		return render :json=>{:placement_status => 0, :message=>"Error: Board with that board id not found."} if board.nil?

		card1_index = params[:card1_index].to_i
		return render :json=>{:placement_status => 0, :message=>"Error: Card1Index is invalid. Please pass a two digit int in string format e.g. \"12\""} if !board.index_in_bounds(card1_index)
		if (!params[:card2_index].nil?)
			card2_index = params[:card2_index].to_i
			return render :json=>{:placement_status => 0, :message=>"Error: Card2Index is invalid. Please pass a two digit int in string format e.g. \"12\""} if !board.index_in_bounds(card2_index)
			touched_only_one_card = false
		end
		return render :json=>{:placement_status => 0, :message=>"Error: Playmate with id" + current_user.id.to_s() +  "is not authorized to change this board"} if !board.user_authorized(current_user.id)
		return render :json=>{:placement_status => 0, :message=>"Error: It is not " + current_user.username.to_s + "'s turn! Try again after opponent makes move."} if !board.is_playmates_turn(current_user.id)
		
		##start RESPONSE formation
		response = {}
		#default responses
		response_message = ""
		board_dump = JSON.dump board
		status_dump = {:has_json => 1,:board_dump => board_dump}
		response.merge(status_dump)

		#get response
		response_code = MATCH_ERROR
		response_message = "Error: Unspecified."

		if (touched_only_one_card)
			if (board.valid_card_at_index(card1_index))
				response_code = FLIP_FIRST_CARD
				response_message = "FLIP first card. Pusher sent!"

				Pusher[@playdate.pusher_channel_name].trigger('games_memory_play_turn', {:message => response_message, :has_json => 0, :placement_status => response_code, :playmate_id => current_user.id, :board_id => board.id, :card1_index => params[:card1_index]})
			else
				response_message = "Flip error: index not valid"

			end
		else #make sure that turn is delegated
			# do they match?
			if (board.is_a_match(card1_index, card2_index))
				response_code_card1 = board.mark_index(card1_index, current_user.id)
				response_code_card2 = board.mark_index(card2_index, current_user.id)
				if ((response_code_card1) && (response_code_card2))
					response_code = MATCH_FOUND
					# board.set_turn(current_user.id) #TODO, does is it your turn till you get a match wrong?
					board.increment_score(current_user.id)

					if (board.we_have_a_winner)
						response_code = MATCH_WINNER
						board.set_winner
					end
				else
					response_code == MATCH_ERROR					
					response_message = "Match, but those spaces already marked."
					board.set_turn(current_user.id)
				end
			else
				response_code == MATCH_ERROR
				response_message = "Not a match."
				board.set_turn(current_user.id)
			end

			if response_code == MATCH_FOUND
				response_message = "Match success. Card1: " + params[:card1_index] + " Card2: " + params[:card2_index]
			elsif response_code == MATCH_WINNER
				response_message = "MATCH SUCCESS, WE HAVE A WINNER. Card1: " + params[:card1_index] + " Card2: " + params[:card2_index]
			end
			if response_code == MATCH_WINNER
				Pusher[@playdate.pusher_channel_name].trigger('games_memory_play_turn', {:winner_id => board.winner, :board_dump => board_dump, :has_json => 0, :placement_status => response_code, :playmate_id => current_user.id, :board_id => board.id, :card1_index => params[:card1_index], :card2_index => params[:card2_index]})
			else
				Pusher[@playdate.pusher_channel_name].trigger('games_memory_play_turn', {:board_dump => board_dump, :has_json => 0, :placement_status => response_code, :playmate_id => current_user.id, :board_id => board.id, :card1_index => params[:card1_index], :card2_index => params[:card2_index]})
			end
		end

		response["has_json"] = 0
		response["message"] = response_message
		response["placement_status"] = response_code
		response["board_dump"] = board_dump
		if MATCH_WINNER == response_code
			response["winner_id"] = board.winner
		end

		render :json => response
	end

	#request params board_id
	def board_to_json
		return render :json=>{:message=>"HTTP POST expects parameter \"board_id\" and an authentication_token. Refer to the API documentation for more info."} if params[:board_id].nil? || params[:authentication_token].nil?

		board = Memoryboard.find_by_id(params[:board_id].to_i)
		return render :json=>{:message=>"Error: Board with that board id not found."} if board.nil?

		dump = JSON.dump board
		return render :json => dump 
	end

	#request params board_id, playdate_id, user_id
	def end_game
		return render :json=>{:message=>"HTTP POST expects parameter \"board_id\", playdate_id, user_id and an authentication_token. Refer to the API documentation for more info."} if params[:board_id].nil? || params[:authentication_token].nil?
		
		current_user = User.find_by_id(params[:user_id])
		return render :json=>{:message=>"Playmate cannot be found."} if current_user.nil?

		# grab the current playdate! 
		@playdate = Playdate.find_by_id(params[:playdate_id])
		return render :json=>{:message=>"Playdate with id: " + params[:playdate_id] + " not found."} if (@playdate.nil? && params[:playdate_id].nil? &&params[:user_id].nil?)

		board = Memoryboard.find_by_id(params[:board_id].to_i)
		return render :json=>{:message=>"Error: Board with that board id not found."} if board.nil?

		board.game_ended_by_user #TODO fix this

		Pusher[@playdate.pusher_channel_name].trigger('games_memory_end_game', {:board_id => board.id, :playmate_id => current_user.id})

		return render :json=>{:message=>"Game has been terminated."}
	end
end
