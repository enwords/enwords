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

ActiveRecord::Schema.define(version: 2020_08_12_182958) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "articles", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "language", limit: 4
    t.string "content", limit: 100000
    t.string "title", limit: 100
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "words_data", default: {}
    t.index ["user_id"], name: "index_articles_on_user_id"
  end

  create_table "external_articles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.string "source"
    t.string "author"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "grammar_eng_idioms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "value", null: false
    t.string "meaning", null: false
    t.integer "weight", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["value"], name: "index_grammar_eng_idioms_on_value", unique: true
  end

  create_table "grammar_eng_irregular_verbs", id: :serial, force: :cascade do |t|
    t.string "infinitive"
    t.jsonb "simple_past", default: []
    t.jsonb "past_participle", default: []
  end

  create_table "grammar_eng_phrasal_verb_meanings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "value", null: false
    t.string "example"
    t.uuid "phrasal_verb_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["phrasal_verb_id"], name: "index_grammar_eng_phrasal_verb_meanings_on_phrasal_verb_id"
  end

  create_table "grammar_eng_phrasal_verbs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "value", null: false
    t.integer "weight", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["value"], name: "index_grammar_eng_phrasal_verbs_on_value", unique: true
  end

  create_table "grammar_eng_user_idioms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.uuid "idiom_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["idiom_id"], name: "index_grammar_eng_user_idioms_on_idiom_id"
    t.index ["user_id", "idiom_id"], name: "index_grammar_eng_user_idioms_on_user_id_and_idiom_id", unique: true
    t.index ["user_id"], name: "index_grammar_eng_user_idioms_on_user_id"
  end

  create_table "grammar_eng_user_irregular_verbs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "irregular_verb_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["irregular_verb_id"], name: "index_grammar_eng_user_irregular_verbs_on_irregular_verb_id"
    t.index ["user_id", "irregular_verb_id"], name: "index_user_on_irregular_verb", unique: true
    t.index ["user_id"], name: "index_grammar_eng_user_irregular_verbs_on_user_id"
  end

  create_table "grammar_eng_user_phrasal_verbs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.uuid "phrasal_verb_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["phrasal_verb_id"], name: "index_grammar_eng_user_phrasal_verbs_on_phrasal_verb_id"
    t.index ["user_id", "phrasal_verb_id"], name: "index_user_on_phrasal_verb", unique: true
    t.index ["user_id"], name: "index_grammar_eng_user_phrasal_verbs_on_user_id"
  end

  create_table "links", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer "sentence_1_id", null: false
    t.integer "sentence_2_id", null: false
    t.index ["sentence_1_id", "sentence_2_id"], name: "index_links_on_sentence_1_id_and_sentence_2_id", unique: true
  end

  create_table "messages", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "message_type"
  end

  create_table "mnemos", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer "word_id"
    t.string "language"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "creative_added", default: false
    t.index ["word_id"], name: "index_mnemos_on_word_id"
  end

  create_table "payment_callbacks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sentences", id: :integer, default: nil, force: :cascade do |t|
    t.string "language", limit: 4
    t.string "value"
    t.integer "tatoeba_id"
    t.boolean "with_audio", default: false
    t.index ["language"], name: "index_sentences_on_language"
  end

  create_table "sentences_words", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer "word_id", null: false
    t.integer "sentence_id", null: false
    t.index ["word_id", "sentence_id"], name: "index_sentences_words_on_word_id_and_sentence_id", unique: true
  end

  create_table "skyeng_settings", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "aasm_state"
    t.string "email", null: false
    t.string "token"
    t.index ["user_id"], name: "index_skyeng_settings_on_user_id"
  end

  create_table "telegram_chats", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer "user_id", null: false
    t.bigint "chat_id", null: false
    t.string "username"
    t.string "first_name"
    t.string "last_name"
    t.boolean "active", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_telegram_chats_on_user_id"
  end

  create_table "trainings", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "words_learned", default: 0, null: false
    t.integer "current_page", default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.jsonb "data"
    t.string "type"
    t.index ["user_id"], name: "index_trainings_on_user_id"
  end

  create_table "user_authentications", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "uid"
    t.string "token"
    t.datetime "token_expires_at"
    t.text "params"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "provider"
    t.index ["user_id"], name: "index_user_authentications_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", limit: 2, default: 0, null: false
    t.integer "native_language", limit: 2
    t.integer "learning_language", limit: 2
    t.integer "sentences_number", limit: 2, default: 5, null: false
    t.boolean "audio_enable", default: false
    t.boolean "diversity_enable", default: false
    t.jsonb "additional_info", default: {}
    t.boolean "promo_email_sent", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "word_statuses", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer "user_id"
    t.integer "word_id"
    t.boolean "learned", null: false
    t.index ["user_id", "word_id"], name: "index_word_statuses_on_user_id_and_word_id", unique: true
    t.index ["user_id"], name: "index_word_statuses_on_user_id"
    t.index ["word_id"], name: "index_word_statuses_on_word_id"
  end

  create_table "words", id: :integer, default: nil, force: :cascade do |t|
    t.string "language", limit: 4
    t.string "value"
    t.string "pos"
    t.integer "weight"
    t.string "transcription"
    t.jsonb "data"
    t.index ["language"], name: "index_words_on_language"
    t.index ["value"], name: "index_words_on_value"
  end

  add_foreign_key "articles", "users"
  add_foreign_key "grammar_eng_phrasal_verb_meanings", "grammar_eng_phrasal_verbs", column: "phrasal_verb_id"
  add_foreign_key "grammar_eng_user_idioms", "grammar_eng_idioms", column: "idiom_id"
  add_foreign_key "grammar_eng_user_idioms", "users"
  add_foreign_key "grammar_eng_user_irregular_verbs", "grammar_eng_irregular_verbs", column: "irregular_verb_id"
  add_foreign_key "grammar_eng_user_irregular_verbs", "users"
  add_foreign_key "grammar_eng_user_phrasal_verbs", "grammar_eng_phrasal_verbs", column: "phrasal_verb_id"
  add_foreign_key "grammar_eng_user_phrasal_verbs", "users"
  add_foreign_key "telegram_chats", "users"
  add_foreign_key "trainings", "users"
end
