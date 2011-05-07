class AddImageDirectoryToBook < ActiveRecord::Migration
  def self.up
    add_column :books, :image_directory, :string
  end

  def self.down
    remove_column :books, :image_directory
  end
end
