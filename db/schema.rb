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

ActiveRecord::Schema.define(version: 20140915035448) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appointments", force: true do |t|
    t.integer "meeting_id"
    t.integer "user_id"
    t.boolean "accepted"
    t.boolean "declined"
  end

  add_index "appointments", ["user_id", "meeting_id"], name: "index_appointments_on_user_id_and_meeting_id", using: :btree

  create_table "authorizations", force: true do |t|
    t.string   "provider",   default: "linkedin"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "connections", force: true do |t|
    t.integer  "conversation_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "connections", ["user_id", "conversation_id"], name: "index_connections_on_user_id_and_conversation_id", using: :btree

  create_table "conversations", force: true do |t|
    t.string   "name"
    t.string   "title"
    t.integer  "creator"
    t.integer  "meeting_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "trashed",    default: false
  end

  create_table "expertises", force: true do |t|
    t.integer "user_id"
    t.integer "skill_id"
  end

  add_index "expertises", ["user_id", "skill_id"], name: "index_expertises_on_user_id_and_skill_id", using: :btree

  create_table "meetings", force: true do |t|
    t.string   "name"
    t.string   "title"
    t.integer  "creator"
    t.integer  "receiver"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "conversation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subject"
  end

  create_table "needed_skills", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skills", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "location"
    t.string   "tagline"
    t.integer  "helpfulness",     default: 3
    t.string   "email"
    t.string   "interests"
    t.string   "profile_pic_url"
    t.string   "li_token"
    t.string   "birthday"
    t.string   "star_sign"
    t.string   "personality"
    t.string   "favorite_book"
    t.string   "favorite_movie"
    t.string   "mon"
    t.string   "tues"
    t.string   "wed"
    t.string   "thurs"
    t.string   "fri"
    t.string   "sat"
    t.string   "sun"
    t.text     "bio"
    t.text     "info"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "education"
  end

  create_table "wants", force: true do |t|
    t.integer "user_id"
    t.integer "needed_skill_id"
  end

  add_index "wants", ["user_id", "needed_skill_id"], name: "index_wants_on_user_id_and_needed_skill_id", using: :btree

end