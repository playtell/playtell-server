class AddStatusToPlaydate < ActiveRecord::Migration
  def self.up
    add_column :playdates, :status, :integer, :default => 0
  end

  def self.down
    remove_column :playdates, :status
  end
end
