class RemovePageImagePathFromPage < ActiveRecord::Migration
  def self.up
    remove_column :pages, :page_image_path
  end

  def self.down
    add_column :pages, :page_image_path
  end
end
