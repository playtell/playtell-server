class CreateContactNotifications < ActiveRecord::Migration
  def self.up
    create_table :contact_notifications do |t|
      t.integer :user_id
      t.string :email
      t.timestamps
    end
  end

  def self.down
    drop_table :contact_notifications
  end
end