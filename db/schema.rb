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

ActiveRecord::Schema.define(version: 20160313212240) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blazer_audits", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "query_id"
    t.text     "statement"
    t.string   "data_source"
    t.datetime "created_at"
  end

  create_table "blazer_checks", force: :cascade do |t|
    t.integer  "query_id"
    t.string   "state"
    t.text     "emails"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blazer_dashboard_queries", force: :cascade do |t|
    t.integer  "dashboard_id"
    t.integer  "query_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blazer_dashboards", force: :cascade do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blazer_queries", force: :cascade do |t|
    t.integer  "creator_id"
    t.string   "name"
    t.text     "description"
    t.text     "statement"
    t.string   "data_source"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chat_users", force: :cascade do |t|
    t.integer  "chat_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "chat_users", ["chat_id", "user_id"], name: "index_chat_users_on_chat_id_and_user_id", unique: true, using: :btree
  add_index "chat_users", ["chat_id"], name: "index_chat_users_on_chat_id", using: :btree
  add_index "chat_users", ["user_id", "chat_id"], name: "index_chat_users_on_user_id_and_chat_id", unique: true, using: :btree
  add_index "chat_users", ["user_id"], name: "index_chat_users_on_user_id", using: :btree

  create_table "chats", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text     "body"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "owner_user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "language_id"
  end

  add_index "comments", ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree
  add_index "comments", ["language_id"], name: "index_comments_on_language_id", using: :btree

  create_table "job_skills", force: :cascade do |t|
    t.integer  "job_id"
    t.integer  "skill_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "job_skills", ["job_id", "skill_id"], name: "index_job_skills_on_job_id_and_skill_id", unique: true, using: :btree
  add_index "job_skills", ["job_id"], name: "index_job_skills_on_job_id", using: :btree
  add_index "job_skills", ["skill_id", "job_id"], name: "index_job_skills_on_skill_id_and_job_id", unique: true, using: :btree
  add_index "job_skills", ["skill_id"], name: "index_job_skills_on_skill_id", using: :btree

  create_table "job_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "job_id"
    t.boolean  "accepted",     default: false
    t.integer  "rate"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "will_perform", default: false
    t.datetime "accepted_at"
  end

  add_index "job_users", ["job_id", "user_id"], name: "index_job_users_on_job_id_and_user_id", unique: true, using: :btree
  add_index "job_users", ["job_id"], name: "index_job_users_on_job_id", using: :btree
  add_index "job_users", ["user_id", "job_id"], name: "index_job_users_on_user_id_and_job_id", unique: true, using: :btree
  add_index "job_users", ["user_id"], name: "index_job_users_on_user_id", using: :btree

  create_table "jobs", force: :cascade do |t|
    t.integer  "max_rate"
    t.text     "description"
    t.datetime "job_date"
    t.boolean  "performed_accept", default: false
    t.boolean  "performed",        default: false
    t.float    "hours"
    t.string   "name"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "owner_user_id"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "language_id"
    t.string   "street"
    t.string   "zip"
    t.float    "zip_latitude"
    t.float    "zip_longitude"
  end

  add_index "jobs", ["language_id"], name: "index_jobs_on_language_id", using: :btree

  create_table "languages", force: :cascade do |t|
    t.string   "lang_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "languages", ["lang_code"], name: "index_languages_on_lang_code", unique: true, using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "chat_id"
    t.integer  "author_id"
    t.integer  "integer"
    t.integer  "language_id"
    t.text     "body"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "messages", ["chat_id"], name: "index_messages_on_chat_id", using: :btree
  add_index "messages", ["language_id"], name: "index_messages_on_language_id", using: :btree

  create_table "ratings", force: :cascade do |t|
    t.integer  "from_user_id"
    t.integer  "to_user_id"
    t.integer  "job_id"
    t.integer  "score",        null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "ratings", ["job_id", "from_user_id"], name: "index_ratings_on_job_id_and_from_user_id", unique: true, using: :btree
  add_index "ratings", ["job_id", "to_user_id"], name: "index_ratings_on_job_id_and_to_user_id", unique: true, using: :btree

  create_table "skills", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "language_id"
  end

  add_index "skills", ["language_id"], name: "index_skills_on_language_id", using: :btree
  add_index "skills", ["name"], name: "index_skills_on_name", unique: true, using: :btree

  create_table "user_languages", force: :cascade do |t|
    t.integer  "language_id"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "user_languages", ["language_id", "user_id"], name: "index_user_languages_on_language_id_and_user_id", unique: true, using: :btree
  add_index "user_languages", ["language_id"], name: "index_user_languages_on_language_id", using: :btree
  add_index "user_languages", ["user_id", "language_id"], name: "index_user_languages_on_user_id_and_language_id", unique: true, using: :btree
  add_index "user_languages", ["user_id"], name: "index_user_languages_on_user_id", using: :btree

  create_table "user_skills", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "skill_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_skills", ["skill_id", "user_id"], name: "index_user_skills_on_skill_id_and_user_id", unique: true, using: :btree
  add_index "user_skills", ["skill_id"], name: "index_user_skills_on_skill_id", using: :btree
  add_index "user_skills", ["user_id", "skill_id"], name: "index_user_skills_on_user_id_and_skill_id", unique: true, using: :btree
  add_index "user_skills", ["user_id"], name: "index_user_skills_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "phone"
    t.text     "description"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "language_id"
    t.boolean  "anonymized",    default: false
    t.string   "auth_token"
    t.string   "password_hash"
    t.string   "password_salt"
    t.boolean  "admin",         default: false
    t.string   "street"
    t.string   "zip"
    t.float    "zip_latitude"
    t.float    "zip_longitude"
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "users", ["auth_token"], name: "index_users_on_auth_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["language_id"], name: "index_users_on_language_id", using: :btree

  add_foreign_key "blazer_audits", "blazer_queries", column: "query_id", name: "blazer_audits_query_id_fk"
  add_foreign_key "blazer_checks", "blazer_queries", column: "query_id", name: "blazer_checks_query_id_fk"
  add_foreign_key "blazer_dashboard_queries", "blazer_queries", column: "query_id", name: "blazer_dashboard_queries_query_id_fk"
  add_foreign_key "blazer_queries", "users", column: "creator_id", name: "blazer_queries_creator_id_fk"
  add_foreign_key "chat_users", "chats"
  add_foreign_key "chat_users", "users"
  add_foreign_key "comments", "languages"
  add_foreign_key "comments", "users", column: "owner_user_id", name: "comments_owner_user_id_fk"
  add_foreign_key "job_skills", "jobs"
  add_foreign_key "job_skills", "skills"
  add_foreign_key "job_users", "jobs"
  add_foreign_key "job_users", "users"
  add_foreign_key "jobs", "languages"
  add_foreign_key "jobs", "users", column: "owner_user_id", name: "jobs_owner_user_id_fk"
  add_foreign_key "messages", "chats"
  add_foreign_key "messages", "languages"
  add_foreign_key "messages", "users", column: "author_id", name: "messages_author_id_fk"
  add_foreign_key "ratings", "jobs", name: "ratings_job_id_fk"
  add_foreign_key "ratings", "users", column: "from_user_id", name: "ratings_from_user_id_fk"
  add_foreign_key "ratings", "users", column: "to_user_id", name: "ratings_to_user_id_fk"
  add_foreign_key "skills", "languages"
  add_foreign_key "user_languages", "languages"
  add_foreign_key "user_languages", "users"
  add_foreign_key "user_skills", "skills"
  add_foreign_key "user_skills", "users"
  add_foreign_key "users", "languages"
end
