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

ActiveRecord::Schema.define(version: 20160609111725) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "eng_sentences", id: :integer, force: :cascade do |t|
    t.string  "sentence"
    t.boolean "is_audio"
  end

  create_table "eng_sentences_rus_sentences", id: false, force: :cascade do |t|
    t.integer "eng_sentence_id"
    t.integer "rus_sentence_id"
    t.index ["eng_sentence_id"], name: "index_eng_sentences_rus_sentences_on_eng_sentence_id", using: :btree
    t.index ["rus_sentence_id"], name: "index_eng_sentences_rus_sentences_on_rus_sentence_id", using: :btree
  end

  create_table "eng_words", id: :integer, force: :cascade do |t|
    t.string "word"
  end

  create_table "eng_words_eng_sentences", id: false, force: :cascade do |t|
    t.integer "eng_word_id"
    t.integer "eng_sentence_id"
    t.index ["eng_sentence_id"], name: "index_eng_words_eng_sentences_on_eng_sentence_id", using: :btree
    t.index ["eng_word_id"], name: "index_eng_words_eng_sentences_on_eng_word_id", using: :btree
  end

  create_table "eng_words_users", id: false, force: :cascade do |t|
    t.integer "eng_word_id"
    t.integer "user_id"
    t.boolean "is_learned"
    t.index ["eng_word_id"], name: "index_eng_words_users_on_eng_word_id", using: :btree
    t.index ["user_id"], name: "index_eng_words_users_on_user_id", using: :btree
  end

  create_table "eng_words_word_collections", id: false, force: :cascade do |t|
    t.integer "eng_word_id"
    t.integer "word_collection_id"
    t.index ["eng_word_id"], name: "index_eng_words_word_collections_on_eng_word_id", using: :btree
    t.index ["word_collection_id"], name: "index_eng_words_word_collections_on_word_collection_id", using: :btree
  end

  create_table "rus_sentences", id: :integer, force: :cascade do |t|
    t.string  "sentence"
    t.boolean "is_audio"
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
    t.string   "role"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "word_collections", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_word_collections_on_user_id", using: :btree
  end

  add_foreign_key "eng_sentences_rus_sentences", "eng_sentences"
  add_foreign_key "eng_sentences_rus_sentences", "rus_sentences"
  add_foreign_key "eng_words_eng_sentences", "eng_sentences"
  add_foreign_key "eng_words_eng_sentences", "eng_words"
  add_foreign_key "eng_words_users", "eng_words"
  add_foreign_key "eng_words_users", "users"
  add_foreign_key "eng_words_word_collections", "eng_words"
  add_foreign_key "eng_words_word_collections", "word_collections"
  add_foreign_key "word_collections", "users"
end
