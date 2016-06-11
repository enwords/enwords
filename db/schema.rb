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

ActiveRecord::Schema.define(version: 20160610201436) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "collections", force: :cascade do |t|
    t.datetime "created_at",                                                                                               null: false
    t.datetime "updated_at",                                                                                               null: false
    t.string   "name",       default: "#<ActiveRecord::ConnectionAdapters::PostgreSQL::TableDefinition:0x00000004100708>", null: false
    t.integer  "user_id"
    t.index ["user_id"], name: "index_collections_on_user_id", using: :btree
  end

  create_table "collections_words", id: false, force: :cascade do |t|
    t.integer "word_id",       null: false
    t.integer "collection_id", null: false
  end

  create_table "eng_sentences", id: :integer, force: :cascade do |t|
    t.string  "sentence"
    t.boolean "is_audio"
  end

  create_table "eng_sentences_rus_sentences", id: false, force: :cascade do |t|
    t.integer "eng_sentence_id", null: false
    t.integer "rus_sentence_id", null: false
  end

  create_table "rus_sentences", id: :integer, force: :cascade do |t|
    t.string  "sentence"
    t.boolean "is_audio"
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
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "users_words", id: false, force: :cascade do |t|
    t.integer "user_id",    null: false
    t.integer "word_id",    null: false
    t.boolean "is_learned"
    t.index ["user_id", "word_id"], name: "index_users_words_on_user_id_and_word_id", unique: true, using: :btree
  end

  create_table "words", id: :integer, force: :cascade do |t|
    t.string "word"
  end

  add_foreign_key "collections", "users"
end
