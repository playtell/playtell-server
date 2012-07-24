class CreateGamesBoards < ActiveRecord::Migration
  def self.up
    create_table :games_boards do |t|
    	t.integer :status
    	t.integer :num_pieces_placed
    	t.integer :winner
    	t.integer :whose_turn
   		t.integer :tictactoe_game_id
   		t.integer :tictactoe_id # TODO remove once renamed properly

      t.timestamps
    end
  end

  def self.down
    drop_table :games_boards
  end
end
