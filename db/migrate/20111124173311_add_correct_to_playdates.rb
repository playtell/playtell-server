class AddCorrectToPlaydates < ActiveRecord::Migration
  def self.up
    add_column :playdates, :correct, :boolean
  end

  def self.down
    remove_column :playdates, :correct
  end
end
