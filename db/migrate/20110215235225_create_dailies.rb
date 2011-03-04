class CreateDailies < ActiveRecord::Migration
  def self.up
    create_table :dailies do |t|
      t.date :d
      t.boolean :kettlebell
      t.boolean :abs
      t.boolean :psoas
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :dailies
  end
end
