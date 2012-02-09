class AddPusherChannelNameToPlaydate < ActiveRecord::Migration
  def self.up
    add_column :playdates, :pusher_channel_name, :string
  end

  def self.down
    remove_column :playdates, :pusher_channel_name
  end
end
