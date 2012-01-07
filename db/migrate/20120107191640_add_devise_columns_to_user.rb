class AddDeviseColumnsToUser < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      # removing old columns used for original auth system
      t.remove :password_salt
      t.remove :password_hash
      t.remove :video_time
      
      # devise stuff
      t.database_authenticatable
      t.recoverable
      t.rememberable
      
      add_index :users, :email,                :unique => true
      add_index :users, :reset_password_token, :unique => true
    end
  end

  def self.down
    # the columns below are manually extracted from devise/schema.rb.
    change_table :users do |t|
      t.remove :encrypted_password
      t.remove :password_salt
      t.remove :authentication_token
      t.remove :reset_password_token
      t.remove :reset_password_sent_at
      t.remove :remember_token
      t.remove :remember_created_at
    end
  end
end
