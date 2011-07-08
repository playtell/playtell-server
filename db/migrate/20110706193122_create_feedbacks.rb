class CreateFeedbacks < ActiveRecord::Migration
  def self.up
    create_table :feedbacks do |t|
      t.integer :user_id
      t.integer :playdate_id
      t.integer :rating
      t.string :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :feedbacks
  end
end
