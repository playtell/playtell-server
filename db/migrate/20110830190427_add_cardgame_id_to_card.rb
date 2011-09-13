class AddCardgameIdToCard < ActiveRecord::Migration
  def self.up
    add_column :cards, :cardgame_id, :integer
  end

  def self.down
    remove_column :cards, :cardgame_id
  end
end
