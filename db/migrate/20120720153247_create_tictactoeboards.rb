class CreateTictactoeboards < ActiveRecord::Migration
  def self.up
    create_table :tictactoeboards do |t|
    	t.integer :status
    	t.integer :num_pieces_placed
    	t.integer :winner
    	t.integer :whose_turn
   		t.integer :tictactoe_game_id
      t.integer :created_by
      t.integer :playmate
   		t.integer :gamelet_id 
      
      t.timestamps
    end
  end

  def self.down
    drop_table :tictactoeboards
  end
end
