class AddApprovalToFriendships < ActiveRecord::Migration
  def self.up
    add_column :friendships, :status, :boolean
    add_column :friendships, :responded_at, :datetime
  end

  def self.down
    remove_column :friendships, :status
    remove_column :friendships, :responded_at
  end
end