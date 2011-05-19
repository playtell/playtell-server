class AddPageNumToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :page_num, :integer
  end

  def self.down
    remove_column :users, :page_num
  end
end
