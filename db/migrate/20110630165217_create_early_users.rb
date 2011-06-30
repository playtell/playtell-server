class CreateEarlyUsers < ActiveRecord::Migration
  def self.up
    create_table :early_users do |t|
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :early_users
  end
end
