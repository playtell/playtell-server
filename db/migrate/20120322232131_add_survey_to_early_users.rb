class AddSurveyToEarlyUsers < ActiveRecord::Migration
  def self.up
    add_column :early_users, :owns_iPad, :integer
    add_column :early_users, :has_kids, :integer
  end

  def self.down
    remove_column :early_users, :has_kids
    remove_column :early_users, :owns_iPad
  end
end
