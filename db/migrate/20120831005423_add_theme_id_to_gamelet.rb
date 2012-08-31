class AddThemeIdToGamelet < ActiveRecord::Migration
  def self.up
  	add_column :gamelets, :theme_id, :integer
  end

  def self.down
  	remove_column :gamelets, :theme_id
  end
end