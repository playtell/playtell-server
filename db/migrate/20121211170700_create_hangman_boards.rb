class CreateHangmanBoards < ActiveRecord::Migration
  def self.up
    create_table :hangman_boards do |t|
      t.integer :state,
      t.integer :playdate_id,
      t.integer :initiator_id,
      t.integer :playmate_id,
      t.integer :misses, :default => 0
      t.integer :whose_turn, :default => 0
      t.integer :winner,
      t.string :word,
      t.string :word_bits

      t.timestamps
    end
  end

  def self.down
    drop_table :hangman_boards
  end
end