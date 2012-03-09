class CreatePlaydatePhotos < ActiveRecord::Migration
  def self.up
    create_table :playdate_photos do |t|
      t.integer :user_id
      t.string :photo

      t.timestamps
    end
  end

  def self.down
    drop_table :playdate_photos
  end
end
