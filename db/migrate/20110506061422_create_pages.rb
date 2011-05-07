class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.integer :book_id
      t.integer :page_num
      t.string :page_image_path
      t.text :page_text

      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
