class AddThemeIdToGamelet < ActiveRecord::Migration
  def self.up
  	add_column :gamelet, :theme_id, :integer
  end

  def self.down
  	remove_column :gamelet, :theme_id
  end
end