class AddDurationToPlaydate < ActiveRecord::Migration
  def self.up
    add_column :playdates, :duration, :integer
  end

  def self.down
    remove_column :playdates, :duration
  end
end
