class AddTitleToGame < ActiveRecord::Migration
  def self.up
    add_column :games, :title, :string
  end

  def self.down
    remove_column :games, :title
  end
end
