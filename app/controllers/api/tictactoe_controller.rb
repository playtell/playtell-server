class Api::TictactoeController < ApplicationController
	# ---- CONSTANTS ----
	# piece placement status codes
	NOT_PLACED = 0
	PLACED_SUCCESS = 1
	PLACED_WON = 2
	PLACED_CATS = 3

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

	 respond_to :json
	 skip_before_filter :verify_authenticity_token
	 before_filter :authenticate_user!

	#request params playmate_id, authentication_token, playdate_id
	def new_game
		return render :json=>{:message=>"API expects the following: playmate_id, playdate_id, authentication_token. Refer to the API documentation for more info."} if params[:authentication_token].nil? || params[:playmate_id].nil? || params[:playdate_id].nil?
	
		# grab the current playdate! 
		@playdate = Playdate.find_by_id(params[:playdate_id])
		return render :json=>{:message=>"Playdate with id: " + params[:playdate_id] + " not found."} if @playdate.nil?

		tictactoe = Tictactoe.create if Tictactoe.first.nil?
		tictactoe = Tictactoe.first

		return render :json=>{:message=>"Playmate cannot be found."} if current_user.nil?

		playmate = User.find_by_id(params[:playmate_id].to_i)
		return render :json=>{:message=>"Playmate with id: " + params[:playmate_id] + " not found."} if playmate.nil?

		board_id = tictactoe.create_new_board(current_user.id, playmate.id)
      	Pusher[@playdate.pusher_channel_name].trigger('games_tictactoe_new_game', {:initiator_id => current_user.id, :board_id => board_id})

		render :json=>{:message=>"Board successfully initialized, playdate id is " + @playdate.id.to_s, :board_id => board_id}
	end

	#request params user_id, board_id, coordinates, with_json
	def place_piece
		##start PARAM validation start
		return render :json=>{:message=>"API expects the following: board_id, playdate_id, authentication_token, coordinates, and user_id. Refer to the API documentation for more info."} if params[:user_id].nil? || params[:board_id].nil? || params[:coordinates].nil?  || params[:playdate_id].nil? || params[:authentication_token].nil?

		current_user = User.find_by_id(params[:user_id])
		return render :json=>{:message=>"Playmate cannot be found."} if current_user.nil?

		#set json response (yes send json w/ response or no)
		json_response = false
		if !params[:with_json].nil?
			json_response = true if params[:with_json] == "true"
		end

		@playdate = Playdate.find_by_id(params[:playdate_id])
		return render :json=>{:placement_status => 0, :message=>"Error: Game has already ended or game is invalid"} if board.status != 0

		return render :json=>{:message=>"Playdate with id: " + params[:playdate_id] + " not found."} if @playdate.nil?

		return render :json=>{:placement_status => 0, :message=>"Error: Playmate cannot be found."} if current_user.nil? #TODO figure out why json status messages don't work in browser

		board = Tictactoeboard.find_by_id(params[:board_id].to_i)
		return render :json=>{:placement_status => 0, :message=>"Error: Board with that board id not found."} if board.nil?

		coordinates = params[:coordinates].to_i
		return render :json=>{:placement_status => 0, :message=>"Error: Coordinates are invalid. Please pass a two digit int in string format e.g. \"12\""} if !board.are_coordinates_in_bounds(coordinates)

		return render :json=>{:placement_status => 0, :message=>"Error: Playmate with id" + current_user.id.to_s() +  "is not authorized to change this board"} if !board.user_authorized(current_user.id)
		return render :json=>{:placement_status => 0, :message=>"Error: It is not " + current_user.username.to_s + "'s turn! Try again after opponent makes move."} if !board.is_playmates_turn(current_user.id)
		
		##start RESPONSE formation
		response = {}
		if json_response
			board_dump = JSON.dump board
			spaces_dump = JSON.dump board.tictactoespaces
			indicators_dump = JSON.dump board.tictactoeindicators
			status_dump = {:has_json => 1,:board_dump => board_dump, :spaces_dump => spaces_dump, :indicators_dump => indicators_dump}
			response.merge(status_dump)
		end

		#default responses
		response_message = ""

		#get response
		response_code = board.mark_location(coordinates, current_user.id)

		if response_code == NOT_PLACED
			response_message = "Placement failed. Another piece at " + params[:coordinates]
		elsif response_code == PLACED_SUCCESS
			response_message = "Placement success at " + params[:coordinates]
		elsif response_code == PLACED_WON
			response_message = "Placement success at " + params[:coordinates] + ". We have a winner!"
		elsif response_code == PLACED_CATS
			response_message = "Placement success at " + params[:coordinates] + ". Cats game!"
		end

		if response_code != NOT_PLACED
			yCor = board.get_space(coordinates).get_y
			xCor = board.get_space(coordinates).get_x
		end

		response["has_json"] = 0
		response["message"] = response_message
		response["placement_code"] = response_code	
		if response_code == PLACED_WON
			response["win_code"] = board.win_code
			Pusher[@playdate.pusher_channel_name].trigger('games_tictactoe_place_piece', {:has_json => 0, :win_code => board.win_code, :placement_code => response_code, :playmate_id => current_user.id, :board_id => board.id, :coordinates => params[:coordinates]})
		end

		Pusher[@playdate.pusher_channel_name].trigger('games_tictactoe_place_piece', {:has_json => 0, :placement_code => response_code, :playmate_id => current_user.id, :board_id => board.id, :coordinates => params[:coordinates]})

		render :json => response
	end

	#request params board_id
	def spaces_to_json
		return render :json=>{:message=>"HTTP POST expects parameter \"board_id\" and an authentication_token. Refer to the API documentation for more info."} if params[:board_id].nil? || params[:authentication_token].nil?

		board = Tictactoeboard.find_by_id(params[:board_id].to_i)
		return render :json=>{:message=>"Error: Board with that board id not found."} if board.nil?

		dump = JSON.dump board.tictactoespaces
		return render :json => dump 
	end

	#request params board_id
	def indicators_to_json
		return render :json=>{:message=>"HTTP POST expects parameter \"board_id\" and an authentication_token. Refer to the API documentation for more info."} if params[:board_id].nil? || params[:authentication_token].nil?

		board = Tictactoeboard.find_by_id(params[:board_id].to_i)
		return render :json=>{:message=>"Error: Board with that board id not found."} if board.nil?

		dump = JSON.dump board.tictactoeindicators
		return render :json => dump 
	end

	#request params board_id
	def board_to_json
		return render :json=>{:message=>"HTTP POST expects parameter \"board_id\" and an authentication_token. Refer to the API documentation for more info."} if params[:board_id].nil? || params[:authentication_token].nil?

		board = Tictactoeboard.find_by_id(params[:board_id].to_i)
		return render :json=>{:message=>"Error: Board with that board id not found."} if board.nil?

		dump = JSON.dump board
		return render :json => dump 
	end

	#request params board_id
	def end_game
		return render :json=>{:message=>"HTTP POST expects parameter \"board_id\" and an authentication_token. Refer to the API documentation for more info."} if params[:board_id].nil? || params[:authentication_token].nil?

		board = Tictactoeboard.find_by_id(params[:board_id].to_i)
		return render :json=>{:message=>"Error: Board with that board id not found."} if board.nil?

		board.game_cats_game #TODO fix this

		Pusher[@playdate.pusher_channel_name].trigger('games_tictactoe_end_game', {:board_id => board.id})

		return render :json=>{:message=>"Game has been terminated."}
	end

end