class AddTokboxTokensToPlaydates < ActiveRecord::Migration
  def self.up
    add_column :playdates, :tokbox_initiator_token, :string
    add_column :playdates, :tokbox_playmate_token, :string
  end

  def self.down
    remove_column :playdates, :tokbox_playmate_token
    remove_column :playdates, :tokbox_initiator_token
  end
end
