class RenameAppToActivityOnGames < ActiveRecord::Migration
  def self.up
    rename_column :games, :app_id, :activity_id
  end

  def self.down
    rename_column :games, :activity_id, :app_id
  end
end
