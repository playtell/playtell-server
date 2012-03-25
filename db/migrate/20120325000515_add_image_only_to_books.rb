class AddImageOnlyToBooks < ActiveRecord::Migration
  def self.up
    add_column :books, :image_only, :integer, :default => 0
  end

  def self.down
    remove_column :books, :image_only
  end
end
