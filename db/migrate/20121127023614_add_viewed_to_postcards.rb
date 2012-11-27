class AddViewedToPostcards < ActiveRecord::Migration
  def self.up
    add_column :postcards, :viewed, :boolean, :default => false
  end

  def self.down
    remove_column :postcards, :viewed
  end
end
