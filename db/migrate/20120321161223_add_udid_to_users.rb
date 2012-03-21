class AddUdidToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :udid, :string
  end

  def self.down
    remove_column :users, :udid
  end
end
