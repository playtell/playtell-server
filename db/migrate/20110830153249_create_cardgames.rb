class CreateCardgames < ActiveRecord::Migration
  def self.up
    create_table :cardgames do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :cardgames
  end
end
