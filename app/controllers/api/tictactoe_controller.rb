class Api::TictactoeController < ApplicationController
	 respond_to :json

	def initialize
		#if no tictactoe object create one
		tictactoe = Tictactoe.create if Tictactoe.first.nil?
	end

	#request params friend_id, playmate
	def new_game
		#grab tictactoe master
		tictactoe = Tictactoe.create if Tictactoe.first.nil?
		tictactoe = Tictactoe.first

		creator = User.find_by_id(params[:friend_id].to_i)
		return render :json=>{:message=>"Playmate with id: " + params[:friend_id] + " not found."} if creator.nil?

		playmate = User.find_by_id(params[:playmate].to_i)
		return render :json=>{:message=>"Playmate with id: " + params[:playmate] + " not found."} if playmate.nil?

		#init board
		board_id = tictactoe.create_new_board(creator.id, playmate.id)

		render :json=>{:message=>"Board successfully initialized", :board_id => board_id}
	end

	#request params friend_id, board_id, coordinates
	def place_piece # TODO fix json response formats and error codes to things that make sense client-side
		# grab parameters
		user = User.find_by_id(params[:friend_id].to_i)
		board = Tictactoeboard.find_by_id(params[:board_id].to_i)
		coordinates = params[:coordinates].to_i

		return render :json=>{:placement_status => 0, :message=>"Error: Playmate with that user id not found."} if user.nil? #TODO figure out why json status messages don't work in browser
		return render :json=>{:placement_status => 0, :message=>"Error: Board with that board id not found."} if board.nil?
		return render :json=>{:placement_status => 0, :message=>"Error: Playmate with that id does not have access to this board"} if !board.user_authorized(user.id)
		return render :json=>{:placement_status => 0, :message=>"Error: Coordinates are invalid. Please pass a two digit int in string format e.g. \"12\""} if !board.coordinates_in_bounds(coordinates)
		return render :json=>{:placement_status => 0, :message=>"Error: Game has already ended or game is invalid"} if board.status != 0

		response_code = board.mark_location(coordinates, user.id)

		#grab board, spaces, and indicators in json format to send to iPads for validation purposes
		board_dump = JSON.dump board
		spaces_dump = JSON.dump board.tictactoespaces
		indicators_dump = JSON.dump board.tictactoeindicators

		if  response_code == 0
			return render :json=>{:placement_status => response_code, :message=>"Error: Piece cannot be placed. Another piece is already at this location", :board_dump => board_dump, :spaces_dump => spaces_dump, :indicators_dump => indicators_dump}
		elsif response_code == 1
			return render :json=>{:placement_status => response_code, :message=>"Piece successfully placed at " + params[:coordinates], :board_dump => board_dump, :spaces_dump => spaces_dump, :indicators_dump => indicators_dump}
		elsif response_code == 2
			return render :json=>{:placement_status => response_code, :message=>"Piece successfully placed. " + params[:friend_id] + " has won!", :board_dump => board_dump, :spaces_dump => spaces_dump, :indicators_dump => indicators_dump}
		elsif response_code == 3
			return render :json=>{:placement_status => response_code, :message=>"Piece successfully placed, but it's a cat's game. MEOW", :board_dump => board_dump, :spaces_dump => spaces_dump, :indicators_dump => indicators_dump}
		else
			return render :json=>{:placement_status => response_code, :message=>"Unknown Error: Response code: " + response_code.to_s(), :board_dump => board_dump, :spaces_dump => spaces_dump, :indicators_dump => indicators_dump}
		end
	end

	#request params board_id
	def spaces_to_json
		board = Tictactoeboard.find_by_id(params[:board_id].to_i)
		return render :json=>{:message=>"Error: Board with that board id not found."} if board.nil?

		dump = JSON.dump board.tictactoespaces
		return render :json => dump 
	end

	#request params board_id
	def indicators_to_json
		board = Tictactoeboard.find_by_id(params[:board_id].to_i)
		return render :json=>{:message=>"Error: Board with that board id not found."} if board.nil?

		dump = JSON.dump board.tictactoeindicators
		return render :json => dump 
	end

	#request params board_id
	def board_to_json
		board = Tictactoeboard.find_by_id(params[:board_id].to_i)
		return render :json=>{:message=>"Error: Board with that board id not found."} if board.nil?

		dump = JSON.dump board
		return render :json => dump 
	end

end