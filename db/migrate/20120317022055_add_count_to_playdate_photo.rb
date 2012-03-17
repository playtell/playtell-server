class AddCountToPlaydatePhoto < ActiveRecord::Migration
  def self.up
    add_column :playdate_photos, :count, :integer
  end

  def self.down
    remove_column :playdate_photos, :count
  end
end
