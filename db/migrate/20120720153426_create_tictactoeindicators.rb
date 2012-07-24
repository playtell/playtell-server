class CreateTictactoeindicators < ActiveRecord::Migration
  def self.up
    create_table :tictactoeindicators do |t|
    	t.integer :x_count
    	t.integer :ycount
    	t.boolean :is_a_row
    	t.integer :row_or_col_index
    	t.integer :board_id

      t.timestamps
    end
  end

  def self.down
    drop_table :tictactoeindicators
  end
end
