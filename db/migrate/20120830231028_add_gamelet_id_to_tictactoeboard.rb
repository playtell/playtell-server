class AddGameletIdToTictactoeboard < ActiveRecord::Migration
  def self.up
  	add_column :tictactoeboards, :gamelet_id, :integer
  end

  def self.down
  	remove_column :tictactoeboards, :gamelet_id
  end
end
