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

ActiveRecord::Schema.define(version: 20150405094611) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "admins", ["user_id"], name: "index_admins_on_user_id", using: :btree

  create_table "advisers", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "advisers", ["user_id"], name: "index_advisers_on_user_id", using: :btree

  create_table "mentors", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "mentors", ["user_id"], name: "index_mentors_on_user_id", using: :btree

  create_table "students", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "team_id"
  end

  add_index "students", ["team_id"], name: "index_students_on_team_id", using: :btree
  add_index "students", ["user_id"], name: "index_students_on_user_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.integer  "adviser_id"
    t.integer  "mentor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "teams", ["adviser_id"], name: "index_teams_on_adviser_id", using: :btree
  add_index "teams", ["mentor_id"], name: "index_teams_on_mentor_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",      default: "",    null: false
    t.string   "provider",   default: "NUS", null: false
    t.string   "uid",                        null: false
    t.string   "user_name",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "admins", "users"
  add_foreign_key "advisers", "users"
  add_foreign_key "mentors", "users"
  add_foreign_key "students", "teams"
  add_foreign_key "students", "users"
  add_foreign_key "teams", "advisers"
  add_foreign_key "teams", "mentors"
end
