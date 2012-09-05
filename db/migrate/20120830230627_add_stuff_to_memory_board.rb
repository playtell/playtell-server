class AddStuffToMemoryBoard < ActiveRecord::Migration
  def self.up
  	add_column :memoryboards, :status, :integer
  	add_column :memoryboards, :winner, :integer
  	add_column :memoryboards, :whose_turn, :integer
  	add_column :memoryboards, :num_cards_left, :integer
  	add_column :memoryboards, :win_code, :integer
  	add_column :memoryboards, :gamelet_id, :integer
  	add_column :memoryboards, :playdate_id, :integer
  	add_column :memoryboards, :playmate_id, :integer
  	add_column :memoryboards, :initiator_id, :integer
  end

  def self.down
  	remove_column :memoryboards, :status, :integer
  	remove_column :memoryboards, :winner, :integer
  	remove_column :memoryboards, :whose_turn, :integer
  	remove_column :memoryboards, :num_cards_left, :integer
  	remove_column :memoryboards, :win_code, :integer
  	remove_column :memoryboards, :gamelet_id, :integer
  	remove_column :memoryboards, :playdate_id, :integer
  	remove_column :memoryboards, :playmate_id, :integer
  	remove_column :memoryboards, :initiator_id, :integer
  end
end
