class AddNumTotalCardsToMemoryboard < ActiveRecord::Migration
  def self.up
  	add_column :num_total_cards, :memoryboard, :integer
  end

  def self.down
  	remove_column :num_total_cards, :memoryboard
  end
end
