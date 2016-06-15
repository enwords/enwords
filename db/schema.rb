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

ActiveRecord::Schema.define(version: 20160612092653) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "audio", id: false, force: :cascade do |t|
    t.integer "sentence_id"
    t.index ["sentence_id"], name: "index_audio_on_sentence_id", using: :btree
  end

  create_table "collections", force: :cascade do |t|
    t.datetime "created_at",                                                                                               null: false
    t.datetime "updated_at",                                                                                               null: false
    t.string   "name",       default: "#<ActiveRecord::ConnectionAdapters::PostgreSQL::TableDefinition:0x000000052fe748>", null: false
    t.integer  "user_id"
    t.index ["user_id"], name: "index_collections_on_user_id", using: :btree
  end

  create_table "collections_words", id: false, force: :cascade do |t|
    t.integer "word_id",       null: false
    t.integer "collection_id", null: false
  end

  create_table "languages", id: :integer, force: :cascade do |t|
    t.string "name"
  end

  create_table "links", id: false, force: :cascade do |t|
    t.integer "sentence_1_id", null: false
    t.integer "sentence_2_id", null: false
    t.index ["sentence_1_id", "sentence_2_id"], name: "index_links_on_sentence_1_id_and_sentence_2_id", unique: true, using: :btree
    t.index ["sentence_1_id"], name: "index_links_on_sentence_1_id", using: :btree
    t.index ["sentence_2_id"], name: "index_links_on_sentence_2_id", using: :btree
  end

  create_table "sentences", id: :integer, force: :cascade do |t|
    t.integer "language_id"
    t.string  "sentence"
    t.index ["language_id"], name: "index_sentences_on_language_id", using: :btree
  end

  create_table "sentences_words", id: false, force: :cascade do |t|
    t.integer "word_id",     null: false
    t.integer "sentence_id", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "role"
    t.integer  "language_1_id",                       null: false
    t.integer  "language_2_id",                       null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["language_1_id"], name: "index_users_on_language_1_id", using: :btree
    t.index ["language_2_id"], name: "index_users_on_language_2_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "users_words", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "word_id", null: false
    t.boolean "learned", null: false
    t.index ["user_id", "word_id"], name: "index_users_words_on_user_id_and_word_id", unique: true, using: :btree
  end

  create_table "words", id: :integer, force: :cascade do |t|
    t.integer "language_id"
    t.string  "word"
    t.index ["language_id"], name: "index_words_on_language_id", using: :btree
  end

  add_foreign_key "audio", "sentences"
  add_foreign_key "collections", "users"
  add_foreign_key "sentences", "languages"
  add_foreign_key "words", "languages"
end
