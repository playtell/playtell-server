class RenameToyboxOrderToPosition < ActiveRecord::Migration
  def self.up
    rename_column :activities, :toybox_order, :position
  end

  def self.down
    rename_column :activities, :position, :toybox_order
  end
end
