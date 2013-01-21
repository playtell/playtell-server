class AddClientIdToGames < ActiveRecord::Migration
  def self.up
    add_column :games, :client_id, :integer
  end

  def self.down
    remove_column :games, :client_id
  end
end
