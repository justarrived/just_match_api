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

ActiveRecord::Schema.define(version: 20151205120338) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "job_skills", force: :cascade do |t|
    t.integer  "job_id"
    t.integer  "skill_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "job_skills", ["job_id"], name: "index_job_skills_on_job_id", using: :btree
  add_index "job_skills", ["skill_id"], name: "index_job_skills_on_skill_id", using: :btree

  create_table "job_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "job_id"
    t.boolean  "accepted",   default: false
    t.integer  "rate"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "job_users", ["job_id"], name: "index_job_users_on_job_id", using: :btree
  add_index "job_users", ["user_id"], name: "index_job_users_on_user_id", using: :btree

  create_table "jobs", force: :cascade do |t|
    t.integer  "max_rate"
    t.text     "description"
    t.datetime "job_date"
    t.boolean  "performed",     default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "owner_user_id"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address"
  end

  create_table "skills", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_skills", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "skill_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_skills", ["skill_id"], name: "index_user_skills_on_skill_id", using: :btree
  add_index "user_skills", ["user_id"], name: "index_user_skills_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address"
  end

  add_foreign_key "job_skills", "jobs"
  add_foreign_key "job_skills", "skills"
  add_foreign_key "job_users", "jobs"
  add_foreign_key "job_users", "users"
  add_foreign_key "user_skills", "skills"
  add_foreign_key "user_skills", "users"
end
