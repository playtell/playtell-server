class CreateGamesSpaces < ActiveRecord::Migration
  def self.up
    create_table :games_spaces do |t|
    	t.integer :friend_id
    	t.boolean :available
    	t.integer :coordinates
    	t.integer :board_id

      t.timestamps
    end
  end

  def self.down
    drop_table :games_spaces
  end
end
