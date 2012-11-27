class AddSenderNameToPostcards < ActiveRecord::Migration
  def self.up
    add_column :postcards, :sender_name, :string
  end

  def self.down
    remove_column :postcards, :sender_name
  end
end
