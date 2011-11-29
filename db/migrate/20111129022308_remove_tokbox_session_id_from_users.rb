class RemoveTokboxSessionIdFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :tokbox_session_id
  end

  def self.down
    add_column :users, :tokbox_session_id, :string
  end
end
