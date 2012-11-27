class CreatePostcards < ActiveRecord::Migration
  def self.up
    create_table :postcards do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.string :photo

      t.timestamps
    end
  end

  def self.down
    drop_table :postcards
  end
end
