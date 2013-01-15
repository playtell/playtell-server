class RenameApp < ActiveRecord::Migration
  def self.up
    rename_table :apps, :activities
  end

  def self.down
    rename_table :activities, :apps
  end
end