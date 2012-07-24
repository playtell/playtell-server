class CreateGamesTictactoes < ActiveRecord::Migration
  def self.up
    create_table :games_tictactoes do |t|
    	t.integer :num_boards
    	t.integer :num_active_games
    	
      t.timestamps
    end
  end

  def self.down
    drop_table :games_tictactoes
  end
end
