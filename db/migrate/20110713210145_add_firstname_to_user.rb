class AddFirstnameToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :firstname, :string
  end

  def self.down
    remove_column :users, :firstname
  end
end
