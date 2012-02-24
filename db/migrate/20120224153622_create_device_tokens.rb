class CreateDeviceTokens < ActiveRecord::Migration
  def self.up
    create_table :device_tokens do |t|
      t.integer :user_id
      t.string :token

      t.timestamps
    end
  end

  def self.down
    drop_table :device_tokens
  end
end
