require 'test_helper'
	OPEN_GAME = 0
	CLOSED_UNFINISHED = 3

class MemoryboardTest < ActiveSupport::TestCase
	test_gamelet = Gamelet.find_by_id(19)
	initiator = User.find_by_id(34)
	playmate = User.find_by_id(35)

	# test "create memory board" do
	# 	board_id = test_gamelet.new_memorygame_board(initiator.id, playmate.id, 10)

	# 	memory_board = Memoryboard.find_by_id(board_id)

	# 	assert memory_board != nil
	# end

	# test "game starts with creators turn" do
	# 	board_id = test_gamelet.new_memorygame_board(initiator.id, playmate.id, 10)
	# 	board = Memoryboard.find_by_id(board_id)

	# 	assert board.whose_turn == 0
	# end

	# test "test card order array" do
	# 	board_id = test_gamelet.new_memorygame_board(initiator.id, playmate.id, 10)
	# 	board = Memoryboard.find_by_id(board_id)
	# 	assert 10 == board.card_array_to_string.size
	# end

	# test "test end game" do
	# 	board_id = test_gamelet.new_memorygame_board(initiator.id, playmate.id, 10)
	# 	board = Memoryboard.find_by_id(board_id)

	# 	board.game_ended_by_user

	# 	assert board.status == CLOSED_UNFINISHED
	# end

	# test "test marking indexes" do
	# 	board_id = test_gamelet.new_memorygame_board(initiator.id, playmate.id, 10)
	# 	board = Memoryboard.find_by_id(board_id)

	# 	assert true == board.mark_index(0, 34)
	# 	assert true == board.mark_index(1, 34)
	# 	assert true == board.mark_index(2, 34)
	# 	assert true == board.mark_index(3, 34)
	# 	assert true == board.mark_index(4, 34)
	# 	assert true == board.mark_index(5, 34)
	# 	assert true == board.mark_index(6, 34)
	# 	assert true == board.mark_index(7, 34)
	# 	assert true == board.mark_index(8, 34)
	# 	assert true == board.mark_index(9, 34)


	# 	assert false == board.mark_index(0, 34)
	# 	assert false == board.mark_index(1, 34)
	# 	assert false == board.mark_index(2, 34)
	# 	assert false == board.mark_index(3, 34)
	# 	assert false == board.mark_index(4, 34)
	# 	assert false == board.mark_index(5, 34)
	# 	assert false == board.mark_index(6, 34)
	# 	assert false == board.mark_index(7, 34)
	# 	assert false == board.mark_index(8, 34)
	# 	assert false == board.mark_index(9, 34)
	# 	assert false == board.mark_index(10, 34)
	# end

	test "test artwork filename array" do
		board_id = test_gamelet.new_memorygame_board(initiator.id, playmate.id, 20)
		board = Memoryboard.find_by_id(board_id)

		filename_array = board.get_array_of_card_backside_filenames
		puts filename_array
	end



end
