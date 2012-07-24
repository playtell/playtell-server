class RenameYcount < ActiveRecord::Migration
  def self.up
  	remove_column :tictactoeindicators, :ycount
  	add_column :tictactoeindicators, :y_count, :integer
  end

  def self.down
  	remove_column :tictactoeindicators, :y_count
  	add_column :tictactoeindicators, :ycount, :integer
  end
end
