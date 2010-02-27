# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100221205738) do

  create_table "abilities", :force => true do |t|
    t.string   "name",       :limit => 32,                :null => false
    t.integer  "star_cost",                :default => 0, :null => false
    t.integer  "time_cost",                :default => 0, :null => false
    t.text     "effect"
    t.text     "attack"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  create_table "card_abilities", :force => true do |t|
    t.integer  "card_id",    :null => false
    t.integer  "ability_id", :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "card_abilities", ["ability_id"], :name => "index_card_abilities_on_ability_id"
  add_index "card_abilities", ["card_id"], :name => "index_card_abilities_on_card_id"

  create_table "cards", :force => true do |t|
    t.string   "name",       :limit => 30, :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "game_cards", :force => true do |t|
    t.integer  "player_id",                    :null => false
    t.integer  "card_id",                      :null => false
    t.integer  "position",                     :null => false
    t.integer  "time_counters", :default => 0, :null => false
    t.integer  "star_counters", :default => 0, :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "game_cards", ["player_id", "position"], :name => "index_game_cards_on_player_id_and_position", :unique => true

  create_table "games", :force => true do |t|
    t.string   "name",                                 :null => false
    t.string   "state",                                :null => false
    t.boolean  "public",             :default => true, :null => false
    t.integer  "rotation_offset",    :default => 0,    :null => false
    t.integer  "turn",               :default => 0,    :null => false
    t.integer  "active_player_id"
    t.integer  "priority_player_id"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "games", ["public"], :name => "index_games_on_public"

  create_table "players", :force => true do |t|
    t.integer  "user_id",                       :null => false
    t.integer  "game_id",                       :null => false
    t.integer  "health",        :default => 50, :null => false
    t.integer  "star_counters", :default => 3,  :null => false
    t.integer  "time_counters", :default => 0,  :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "players", ["game_id"], :name => "index_players_on_game_id"
  add_index "players", ["user_id"], :name => "index_players_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "display_name"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

end
