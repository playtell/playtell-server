class AddCardArrayStringToMemoryboard < ActiveRecord::Migration
  def self.up
  	add_column :memoryboards, :card_array_string, :string
  end

  def self.down
  	remove_column :memoryboards, :card_array_string
  end
end
