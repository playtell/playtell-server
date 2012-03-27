class AddUsernameToEarlyUsers < ActiveRecord::Migration
  def self.up
    add_column :early_users, :username, :string
  end

  def self.down
    remove_column :early_users, :username
  end
end
