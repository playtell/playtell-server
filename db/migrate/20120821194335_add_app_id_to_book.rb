class AddAppIdToBook < ActiveRecord::Migration
  def self.up
    add_column :books, :app_id, :integer
  end

  def self.down
    remove_column :books, :app_id
  end
end
