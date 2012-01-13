class AddTempToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :temporary, :boolean
  end

  def self.down
    remove_column :users, :temporary
  end
end
