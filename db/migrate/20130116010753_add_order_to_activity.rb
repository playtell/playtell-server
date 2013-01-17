class AddOrderToActivity < ActiveRecord::Migration
  def self.up
    add_column :activities, :order, :integer, :default => 0
  end

  def self.down
    remove_column :activities, :order
  end
end
