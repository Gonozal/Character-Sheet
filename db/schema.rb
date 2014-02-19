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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140218122229) do

  create_table "characters", force: true do |t|
    t.integer  "level"
    t.integer  "experience"
    t.integer  "hit_points"
    t.integer  "temp_hp",                                default: 0
    t.integer  "current_hp",                             default: 0
    t.integer  "healing_surges"
    t.string   "name"
    t.decimal  "height",         precision: 3, scale: 2
    t.decimal  "weight",         precision: 5, scale: 2
    t.string   "gender"
    t.integer  "age"
    t.string   "alignment"
    t.string   "company"
    t.string   "carried_money"
    t.string   "stored_money"
    t.string   "traits"
    t.string   "appearance"
    t.string   "notes"
    t.string   "companions"
    t.string   "race"
    t.string   "klass"
    t.integer  "speed"
    t.integer  "initiative"
    t.integer  "ac",                                                 null: false
    t.integer  "fortitude",                                          null: false
    t.integer  "reflex",                                             null: false
    t.integer  "will",                                               null: false
    t.integer  "strength",                                           null: false
    t.integer  "constitution",                                       null: false
    t.integer  "dexterity",                                          null: false
    t.integer  "intelligence",                                       null: false
    t.integer  "wisdom",                                             null: false
    t.integer  "charisma",                                           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "display_rules", force: true do |t|
    t.string   "name"
    t.integer  "display_order"
    t.string   "formatting"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feats", force: true do |t|
    t.integer  "character_id"
    t.string   "name"
    t.text     "description"
    t.string   "short"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "imports", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "power_attributes", force: true do |t|
    t.integer  "power_id"
    t.integer  "display_rule_id"
    t.string   "name"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "power_weapons", force: true do |t|
    t.integer  "power_id"
    t.string   "name"
    t.integer  "attack_bonus"
    t.string   "damage"
    t.string   "damage_type",       default: "untyped"
    t.string   "defense"
    t.string   "hit_components"
    t.string   "damage_components"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "powers", force: true do |t|
    t.integer  "character_id"
    t.integer  "level",        default: 1
    t.string   "name"
    t.string   "display"
    t.string   "action_type"
    t.string   "attack_type"
    t.string   "power_usage"
    t.text     "flavor"
    t.boolean  "child",        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skills", force: true do |t|
    t.integer  "character_id"
    t.string   "name"
    t.integer  "trained"
    t.string   "stat"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
