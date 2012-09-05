class CreateGamelets < ActiveRecord::Migration
  def self.up
    create_table :gamelets do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :gamelets
  end
end
