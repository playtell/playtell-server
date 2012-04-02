class ChangeTokenStringsToText < ActiveRecord::Migration
  def self.up
    change_column :playdates, :tokbox_initiator_token, :text
    change_column :playdates, :tokbox_playmate_token, :text
  end

  def self.down
    change_column :playdates, :tokbox_initiator_token, :string
    change_column :playdates, :tokbox_playmate_token, :string
  end
end
