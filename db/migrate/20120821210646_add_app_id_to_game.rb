class AddAppIdToGame < ActiveRecord::Migration
  def self.up
    add_column :games, :app_id, :integer
  end

  def self.down
    remove_column :games, :app_id
  end
end
