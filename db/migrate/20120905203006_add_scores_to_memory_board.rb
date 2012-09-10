class AddScoresToMemoryBoard < ActiveRecord::Migration
  def self.up
  	add_column :memoryboards, :initiator_score, :integer
  	add_column :memoryboards, :playmate_score, :integer
  end

  def self.down
  	remove_column :memoryboards, :initiator_score
  	remove_column :memoryboards, :playmate_score
  end
end
