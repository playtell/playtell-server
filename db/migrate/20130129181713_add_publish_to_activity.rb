class AddPublishToActivity < ActiveRecord::Migration
  def self.up
    add_column :activities, :publish, :integer, :default => 0
  end

  def self.down
    remove_column :activities, :publish
  end
end
