class CreateMemoryboards < ActiveRecord::Migration
  def self.up
    create_table :memoryboards do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :memoryboards
  end
end
