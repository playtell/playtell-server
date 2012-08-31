class AddStuffToGamelet < ActiveRecord::Migration
  def self.up
  	add_column :theme_id, :gamelet, :integer
  end

  def self.down
  	remove_column :theme_id, :gamelet
  end
end
