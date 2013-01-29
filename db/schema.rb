# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130129181713) do

  create_table "activities", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.integer  "position",   :default => 0
    t.integer  "publish",    :default => 0
  end

  create_table "boards", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "books", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_directory"
    t.integer  "image_only",      :default => 0
    t.integer  "activity_id"
  end

  create_table "cardgames", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "faceup1"
    t.integer  "faceup2"
    t.integer  "num_matches"
  end

  create_table "cards", :force => true do |t|
    t.integer  "num"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cardgame_id"
  end

  create_table "contact_notifications", :force => true do |t|
    t.integer  "user_id"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "email"
    t.string   "source"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts", ["user_id", "email"], :name => "index_contacts_on_user_id_and_email"
  add_index "contacts", ["user_id", "name"], :name => "index_contacts_on_user_id_and_name"

  create_table "device_tokens", :force => true do |t|
    t.integer  "user_id"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "PT_token"
    t.string   "version"
  end

  create_table "early_users", :force => true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owns_iPad"
    t.integer  "has_kids"
    t.string   "username"
  end

  create_table "feedbacks", :force => true do |t|
    t.integer  "user_id"
    t.integer  "playdate_id"
    t.integer  "rating"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "status"
    t.datetime "responded_at"
  end

  create_table "gamelets", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "theme_id"
  end

  create_table "games", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "activity_id"
    t.integer  "client_id"
  end

  create_table "games_boards", :force => true do |t|
    t.integer  "status"
    t.integer  "num_pieces_placed"
    t.integer  "winner"
    t.integer  "whose_turn"
    t.integer  "tictactoe_game_id"
    t.integer  "tictactoe_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games_indicators", :force => true do |t|
    t.integer  "x_count"
    t.integer  "ycount"
    t.boolean  "is_a_row"
    t.integer  "row_or_col_index"
    t.integer  "board_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games_spaces", :force => true do |t|
    t.integer  "friend_id"
    t.boolean  "available"
    t.integer  "coordinates"
    t.integer  "board_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games_tictactoe_boards", :force => true do |t|
    t.integer  "status"
    t.integer  "num_pieces_placed"
    t.integer  "winner"
    t.integer  "whose_turn"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games_tictactoe_indicators", :force => true do |t|
    t.integer  "x_count"
    t.integer  "ycount"
    t.boolean  "is_a_row"
    t.integer  "row_or_col_index"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games_tictactoe_spaces", :force => true do |t|
    t.integer  "friend_id"
    t.boolean  "available"
    t.integer  "coordinates"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games_tictactoes", :force => true do |t|
    t.integer  "num_boards"
    t.integer  "num_active_games"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hangman_boards", :force => true do |t|
    t.integer  "state"
    t.integer  "playdate_id"
    t.integer  "initiator_id"
    t.integer  "playmate_id"
    t.integer  "misses",       :default => 0
    t.integer  "whose_turn",   :default => 0
    t.integer  "winner"
    t.string   "word"
    t.string   "word_bits"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "indicators", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matchingboards", :force => true do |t|
    t.integer  "gamelet_id"
    t.integer  "playdate_id"
    t.integer  "initiator_id"
    t.integer  "playmate_id"
    t.integer  "initiator_score"
    t.integer  "playmate_score"
    t.integer  "status"
    t.integer  "winner"
    t.integer  "whose_turn"
    t.integer  "num_cards_left"
    t.integer  "win_code"
    t.integer  "num_total_cards"
    t.string   "card_array_string"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memoryboards", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status"
    t.integer  "winner"
    t.integer  "whose_turn"
    t.integer  "num_cards_left"
    t.integer  "win_code"
    t.integer  "gamelet_id"
    t.integer  "playdate_id"
    t.integer  "playmate_id"
    t.integer  "initiator_id"
    t.integer  "num_total_cards"
    t.string   "card_array_string"
    t.integer  "initiator_score"
    t.integer  "playmate_score"
  end

  create_table "pages", :force => true do |t|
    t.integer  "book_id"
    t.integer  "page_num"
    t.text     "page_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "playdate_photos", :force => true do |t|
    t.integer  "user_id"
    t.string   "photo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "playdate_id"
    t.integer  "count"
  end

  create_table "playdates", :force => true do |t|
    t.integer  "player1_id"
    t.integer  "player2_id"
    t.integer  "book_id"
    t.integer  "page_num"
    t.string   "video_session_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",                 :default => 1
    t.integer  "change"
    t.integer  "duration"
    t.boolean  "correct"
    t.string   "pusher_channel_name"
    t.text     "tokbox_initiator_token"
    t.text     "tokbox_playmate_token"
  end

  create_table "postcards", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.string   "photo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "viewed",      :default => false
    t.string   "sender_name"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "spaces", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tictactoeboards", :force => true do |t|
    t.integer  "status"
    t.integer  "num_pieces_placed"
    t.integer  "winner"
    t.integer  "whose_turn"
    t.integer  "tictactoe_game_id"
    t.integer  "tictactoe_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "playmate"
    t.integer  "win_code"
    t.integer  "gamelet_id"
  end

  create_table "tictactoeindicators", :force => true do |t|
    t.integer  "x_count"
    t.boolean  "is_a_row"
    t.integer  "row_or_col_index"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tictactoeboard_id"
    t.integer  "y_count"
  end

  create_table "tictactoes", :force => true do |t|
    t.integer  "num_boards"
    t.integer  "num_active_games"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tictactoespaces", :force => true do |t|
    t.integer  "friend_id"
    t.boolean  "available"
    t.integer  "coordinates"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tictactoeboard_id"
  end

  create_table "user_settings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "key"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "temporary"
    t.string   "authentication_token"
    t.string   "udid"
    t.integer  "status"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
