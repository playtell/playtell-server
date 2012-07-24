class AddTictactoenumberToGames < ActiveRecord::Migration
  def self.up
  	add_column :games, :tictactoe_number, :integer
  end

  def self.down
  	remove_column :games, :tictactoe_number
  end
end
