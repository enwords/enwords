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

ActiveRecord::Schema.define(version: 20160721055643) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "language",   limit: 4
    t.string   "content",    limit: 100000
    t.string   "title",      limit: 100
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["user_id"], name: "index_articles_on_user_id", using: :btree
  end

  create_table "audios", id: false, force: :cascade do |t|
    t.integer "sentence_id"
    t.index ["sentence_id"], name: "index_audios_on_sentence_id", using: :btree
  end

  create_table "links", id: false, force: :cascade do |t|
    t.integer "sentence_1_id", null: false
    t.integer "sentence_2_id", null: false
    t.index ["sentence_1_id", "sentence_2_id"], name: "index_links_on_sentence_1_id_and_sentence_2_id", unique: true, using: :btree
  end

  create_table "sentences", id: :integer, force: :cascade do |t|
    t.string "language", limit: 4
    t.string "sentence"
    t.index ["language"], name: "index_sentences_on_language", using: :btree
  end

  create_table "sentences_words", id: false, force: :cascade do |t|
    t.integer "word_id",     null: false
    t.integer "sentence_id", null: false
    t.index ["word_id", "sentence_id"], name: "index_sentences_words_on_word_id_and_sentence_id", unique: true, using: :btree
  end

  create_table "training_sentences", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "sentence_id"
    t.index ["sentence_id"], name: "index_training_sentences_on_sentence_id", using: :btree
    t.index ["user_id"], name: "index_training_sentences_on_user_id", using: :btree
  end

  create_table "training_words", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "word_id"
    t.index ["user_id"], name: "index_training_words_on_user_id", using: :btree
    t.index ["word_id"], name: "index_training_words_on_word_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                            default: "", null: false
    t.string   "encrypted_password",               default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                    default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "role",                   limit: 2
    t.integer  "native_language",        limit: 2
    t.integer  "learning_language",      limit: 2
    t.integer  "sentences_number",       limit: 2
    t.boolean  "audio_enable"
    t.boolean  "diversity_enable"
    t.integer  "learned_words_count"
    t.integer  "last_training"
    t.integer  "training_page"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "word_in_articles", id: false, force: :cascade do |t|
    t.integer "article_id"
    t.integer "word_id"
    t.integer "frequency"
    t.index ["article_id", "word_id"], name: "index_word_in_articles_on_article_id_and_word_id", unique: true, using: :btree
    t.index ["article_id"], name: "index_word_in_articles_on_article_id", using: :btree
    t.index ["word_id"], name: "index_word_in_articles_on_word_id", using: :btree
  end

  create_table "word_statuses", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "word_id"
    t.boolean "learned", null: false
    t.index ["user_id", "word_id"], name: "index_word_statuses_on_user_id_and_word_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_word_statuses_on_user_id", using: :btree
    t.index ["word_id"], name: "index_word_statuses_on_word_id", using: :btree
  end

  create_table "words", id: :integer, force: :cascade do |t|
    t.string "language", limit: 4
    t.string "word"
    t.index ["language"], name: "index_words_on_language", using: :btree
  end

  add_foreign_key "articles", "users"
  add_foreign_key "audios", "sentences"
end
