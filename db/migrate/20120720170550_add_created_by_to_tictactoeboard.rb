class AddCreatedByToTictactoeboard < ActiveRecord::Migration
  def self.up
  	add_column :tictactoeboards, :created_by, :integer
  end

  def self.down
  	 add_column :tictactoeboards, :created_by
  end
end
