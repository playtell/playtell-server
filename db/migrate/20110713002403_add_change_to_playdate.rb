class AddChangeToPlaydate < ActiveRecord::Migration
  def self.up
    add_column :playdates, :change, :integer
  end

  def self.down
    remove_column :playdates, :change
  end
end
