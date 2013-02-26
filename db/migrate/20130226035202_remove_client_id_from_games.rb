class RemoveClientIdFromGames < ActiveRecord::Migration
  def self.up
    remove_column :games, :client_id
  end

  def self.down
  end
end
