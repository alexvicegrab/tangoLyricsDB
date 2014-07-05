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

ActiveRecord::Schema.define(version: 20140705005317) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "genres", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "songs_count", default: 0
  end

  create_table "languages", force: true do |t|
    t.string   "iso"
    t.string   "name"
    t.integer  "translations_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "songs", force: true do |t|
    t.string   "title"
    t.string   "composer"
    t.string   "lyricist"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "year"
    t.integer  "genre_id"
    t.integer  "translations_count", default: 0
    t.string   "search_title"
  end

  create_table "translations", force: true do |t|
    t.string   "link"
    t.integer  "song_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "language_id",   default: 1
    t.integer  "translator_id", default: 0
    t.boolean  "active",        default: true
  end

  add_index "translations", ["language_id"], name: "index_translations_on_language_id", using: :btree
  add_index "translations", ["song_id"], name: "index_translations_on_song_id", using: :btree

  create_table "translators", force: true do |t|
    t.string   "name"
    t.string   "site_name"
    t.string   "site_link"
    t.integer  "translations_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
