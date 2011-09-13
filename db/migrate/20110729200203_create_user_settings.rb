class CreateUserSettings < ActiveRecord::Migration
  def self.up
    create_table :user_settings do |t|
      t.integer :user_id
      t.integer :key
      t.integer :value

      t.timestamps
    end
  end

  def self.down
    drop_table :user_settings
  end
end
