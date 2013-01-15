class RenameAppIdToActivityId < ActiveRecord::Migration
  def self.up
    rename_column :books, :app_id, :activity_id
  end

  def self.down
    rename_column :books, :activity_id, :app_id
  end
end
