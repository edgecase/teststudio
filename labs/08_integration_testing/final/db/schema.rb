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

ActiveRecord::Schema.define(:version => 20101101204604) do

  create_table "faces", :force => true do |t|
    t.integer  "value"
    t.integer  "position"
    t.integer  "roll_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", :force => true do |t|
    t.integer  "current_player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matches", :force => true do |t|
    t.integer  "winner_id"
    t.integer  "winner_new_rank"
    t.integer  "winner_old_rank"
    t.integer  "loser_id"
    t.integer  "loser_new_rank"
    t.integer  "loser_old_rank"
    t.date     "played_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "rank",       :default => 1000
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "members", ["email"], :name => "index_members_on_email", :unique => true
  add_index "members", ["name"], :name => "index_members_on_name", :unique => true

  create_table "players", :force => true do |t|
    t.string   "type"
    t.string   "name"
    t.integer  "game_id"
    t.integer  "score",      :default => 0
    t.string   "strategy"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rolls", :force => true do |t|
    t.integer  "score"
    t.integer  "unused"
    t.string   "action_name"
    t.integer  "turn_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "turns", :force => true do |t|
    t.integer  "player_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
