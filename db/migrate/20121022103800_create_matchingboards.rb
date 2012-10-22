class CreateMatchingboards < ActiveRecord::Migration
	def self.up
		create_table :memoryboards do |t|
			t.integer :gamelet_id
			t.integer :playdate_id
			t.integer :initiator_id
			t.integer :playmate_id
			t.integer :initiator_score
			t.integer :playmate_score
			t.integer :status
			t.integer :winner
			t.integer :whose_turn
			t.integer :num_cards_left
			t.integer :win_code
			t.integer :num_total_cards
			t.string :card_array_string
			t.timestamps
		end
	end

	def self.down
		drop_table :memoryboards
	end
end