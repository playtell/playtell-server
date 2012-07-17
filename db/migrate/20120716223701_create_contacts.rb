class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.integer :user_id
      t.string :name
      t.string :email
      t.string :source # google, address book, etc.

      t.timestamps
    end
    add_index(:contacts, [:user_id, :name])
    add_index(:contacts, [:user_id, :email])
  end

  def self.down
    drop_table :contacts
  end
end