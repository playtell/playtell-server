class CreatePlaydates < ActiveRecord::Migration
  def self.up
    create_table :playdates do |t|
      t.integer :player1_id
      t.integer :player2_id
      t.integer :book_id
      t.integer :page_num
      t.string :video_session_id

      t.timestamps
    end
  end

  def self.down
    drop_table :playdates
  end
end
