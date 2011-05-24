class RemovePageNumFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :page_num
  end

  def self.down
    add_column :users, :page_num
  end
end
