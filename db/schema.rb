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

ActiveRecord::Schema.define(:version => 20110713002403) do

  create_table "books", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_directory"
  end

  create_table "dailies", :force => true do |t|
    t.date     "d"
    t.boolean  "kettlebell"
    t.boolean  "abs"
    t.boolean  "psoas"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "early_users", :force => true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
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
  end

  create_table "pages", :force => true do |t|
    t.integer  "book_id"
    t.integer  "page_num"
    t.text     "page_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "playdates", :force => true do |t|
    t.integer  "player1_id"
    t.integer  "player2_id"
    t.integer  "book_id"
    t.integer  "page_num"
    t.string   "video_session_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",           :default => 1
    t.integer  "change"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "tokbox_session_id", :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_salt"
    t.string   "password_hash"
  end

end
