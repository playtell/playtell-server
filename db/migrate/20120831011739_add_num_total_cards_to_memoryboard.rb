class AddNumTotalCardsToMemoryboard < ActiveRecord::Migration
  def self.up
  	add_column :memoryboards, :num_total_cards, :integer
  end

  def self.down
  	remove_column :memoryboards, :num_total_cards
  end
end
