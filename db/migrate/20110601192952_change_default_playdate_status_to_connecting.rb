class ChangeDefaultPlaydateStatusToConnecting < ActiveRecord::Migration
  def self.up
    change_column_default :playdates, :status, 1
  end

  def self.down
    change_column_default :playdates, :status, 0
  end
end
