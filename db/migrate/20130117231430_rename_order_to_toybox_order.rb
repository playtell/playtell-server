class RenameOrderToToyboxOrder < ActiveRecord::Migration
  def self.up
    rename_column :activities, :order, :toybox_order
  end

  def self.down
    rename_column :activities, :toybox_order, :order
  end
end
