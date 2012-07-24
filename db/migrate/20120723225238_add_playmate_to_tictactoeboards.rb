class AddPlaymateToTictactoeboards < ActiveRecord::Migration
  def self.up
  	add_column :tictactoeboards, :playmate, :integer
  end

  def self.down
  	remove_column :tictactoeboards, :playmate
  end
end
