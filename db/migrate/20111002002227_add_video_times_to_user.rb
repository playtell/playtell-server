class AddVideoTimesToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :video_time, :integer
  end

  def self.down
    remove_column :users, :video_time
  end
end
