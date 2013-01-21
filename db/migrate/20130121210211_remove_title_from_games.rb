class RemoveTitleFromGames < ActiveRecord::Migration
  def self.up
    remove_column :games, :title
  end

  def self.down
    add_column :games, :title
  end
end
