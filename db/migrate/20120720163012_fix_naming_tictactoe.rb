class FixNamingTictactoe < ActiveRecord::Migration
  def self.up
  	remove_column :tictactoeindicators, :board_id
  	add_column :tictactoeindicators, :tictactoeboard_id, :integer
  	add_column :tictactoespaces, :tictactoeboard_id, :integer
  end

  def self.down
  	remove_column :tictactoeindicators, :tictactoeboard_id
  	remove_column :tictactoespaces, :tictactoeboard_id
  	add_column :tictactoeindicators, :board_id, :integer
  end
end
