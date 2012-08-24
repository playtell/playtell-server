class AddTitleToApp < ActiveRecord::Migration
  def self.up
    add_column :apps, :title, :string
  end

  def self.down
    remove_column :apps, :title
  end
end
