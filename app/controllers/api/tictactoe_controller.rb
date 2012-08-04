class Api::TictactoeController < ApplicationController
	# ---- CONSTANTS ----
	# game status
	OPEN_GAME = 0
	CLOSED_WON = 1
	CLOSED_CATS = 2
	CLOSED_UNFINISHED = 3

	# piece placement
	NOT_PLACED = 0
	PLACED_SUCCESS = 1
	PLACED_WON = 2
	PLACED_CATS = 3

	 respond_to :json
	 skip_before_filter :verify_authenticity_token
	 before_filter :authenticate_user!

	#request params playmate_id
	def new_game
		return render :json=>{:message=>"HTTP POST expects \"playmate_id\" and playdate_id and authentication_token as parameters. Refer to the API documentation for more info."} if params[:authentication_token].nil? || params[:playmate_id].nil? || params[:playdate_id].nil?
	
		# grab the current playdate! 
		@playdate = Playdate.find_by_id(params[:playdate_id])
		return render :json=>{:message=>"Playdate with id: " + params[:playdate_id] + " not found."} if playdate.nil?

		tictactoe = Tictactoe.create if Tictactoe.first.nil?
		tictactoe = Tictactoe.first

		return render :json=>{:message=>"Playmate cannot be found."} if current_user.nil?

		playmate = User.find_by_id(params[:playmate_id].to_i)
		return render :json=>{:message=>"Playmate with id: " + params[:playmate_id] + " not found."} if playmate.nil?

		board_id = tictactoe.create_new_board(current_user.id, playmate.id)
      	Pusher[@playdate.pusher_channel_name].trigger('tictactoe_start', {:initiator_id => current_user.id, :playmate_id => params[:playmate_id], :board_id => board_id})

		render :json=>{:message=>"Board successfully initialized", :board_id => board_id}
	end

	#request params user_id, board_id, coordinates
	def place_piece
		return render :json=>{:message=>"HTTP POST expects parameters \"board_id\", and \"coordinates\"and user_id. Refer to the API documentation for more info."} if params[:user_id].nil? || params[:board_id].nil? || params[:coordinates].nil?

		current_user = User.find_by_id(params[:user_id])

		return render :json=>{:placement_status => 0, :message=>"Error: Playmate cannot be found."} if current_user.nil? #TODO figure out why json status messages don't work in browser

		board = Tictactoeboard.find_by_id(params[:board_id].to_i)
		return render :json=>{:placement_status => 0, :message=>"Error: Board with that board id not found."} if board.nil?

		coordinates = params[:coordinates].to_i
		return render :json=>{:placement_status => 0, :message=>"Error: Coordinates are invalid. Please pass a two digit int in string format e.g. \"12\""} if !board.are_coordinates_in_bounds(coordinates)

		return render :json=>{:placement_status => 0, :message=>"Error: Playmate with id" + current_user.id.to_s() +  "is not authorized to change this board"} if !board.user_authorized(current_user.id)
		return render :json=>{:placement_status => 0, :message=>"Error: It is not the turn of playmate " + current_user.authentication_token.to_s + " . Try again after opponent makes move."} if !board.is_playmates_turn(current_user.id)
		return render :json=>{:placement_status => 0, :message=>"Error: Game has already ended or game is invalid"} if board.status != 0

		response_code = board.mark_location(coordinates, current_user.id)

		#grab board, spaces, and indicators in json format to send to iPads for validation purposes
		board_dump = JSON.dump board
		spaces_dump = JSON.dump board.tictactoespaces
		indicators_dump = JSON.dump board.tictactoeindicators

		# TODO try not to repeat code here (playdate.rb, user.rb have examples of using constants)
		if  response_code == NOT_PLACED
			return render :json=>{:placement_status => response_code, :message=>"Error: Piece cannot be placed. Another piece is already at this location", :board_dump => board_dump, :spaces_dump => spaces_dump, :indicators_dump => indicators_dump}
		elsif response_code == PLACED_SUCCESS
			return render :json=>{:placement_status => response_code, :message=>"Piece successfully placed at " + params[:coordinates], :board_dump => board_dump, :spaces_dump => spaces_dump, :indicators_dump => indicators_dump}
		elsif response_code == PLACED_WON
			return render :json=>{:placement_status => response_code, :message=>"Piece successfully placed. " + params[:user_id] + " has won!", :board_dump => board_dump, :spaces_dump => spaces_dump, :indicators_dump => indicators_dump}
		elsif response_code == PLACED_CATS
			return render :json=>{:placement_status => response_code, :message=>"Piece successfully placed, but it's a cat's game. MEOW", :board_dump => board_dump, :spaces_dump => spaces_dump, :indicators_dump => indicators_dump}
		end
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
		return render :json=>{:message=>"Game has been terminated."}
	end

end