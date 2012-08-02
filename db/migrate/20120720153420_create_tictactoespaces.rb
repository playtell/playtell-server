class CreateTictactoespaces < ActiveRecord::Migration
  def self.up
    create_table :tictactoespaces do |t|
    	t.integer :friend_id
    	t.boolean :available
    	t.integer :coordinates
    	t.integer :tictactoeboard_id

      t.timestamps
    end
  end

  def self.down
    drop_table :tictactoespaces
  end
end
