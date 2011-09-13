class AddSynchFieldsToCardgame < ActiveRecord::Migration
  def self.up
    add_column :cardgames, :faceup1, :integer
    add_column :cardgames, :faceup2, :integer
    add_column :cardgames, :num_matches, :integer
  end

  def self.down
    remove_column :cardgames, :faceup1
    remove_column :cardgames, :faceup2
    remove_column :cardgames, :num_matches
  end
end
