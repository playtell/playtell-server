class AddColumnWinCodeToTictactoeboard < ActiveRecord::Migration
  def self.up
    add_column :tictactoeboards, :win_code, :integer
  end

  def self.down
    remove_column :tictactoeboards, :win_code
  end
end
