class AddPtTokenAndVersionToDeviceToken < ActiveRecord::Migration
  def self.up
    add_column :device_tokens, :PT_token, :string
    add_column :device_tokens, :version, :string
  end

  def self.down
    remove_column :device_tokens, :version
    remove_column :device_tokens, :PT_token
  end
end
