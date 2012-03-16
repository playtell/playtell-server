class AddPlaydateIdToPlaydatePhotos < ActiveRecord::Migration
  def self.up
    add_column :playdate_photos, :playdate_id, :integer
  end

  def self.down
    remove_column :playdate_photos, :playdate_id
  end
end
