class RemoveEverythingFromGame < ActiveRecord::Migration
  def self.up
    remove_column :games, :type
    remove_column :games, :playdate_id
    remove_column :games, :tictactoe_number
    
  end

  def self.down
    add_column :games, :type
    add_column :games, :playdate_id
    add_column :games, :tictactoe_number
  end
end