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

ActiveRecord::Schema.define(version: 20170102205042) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

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

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "frilans_finans_id"
    t.integer  "insurance_status"
    t.index ["frilans_finans_id"], name: "index_categories_on_frilans_finans_id", unique: true, using: :btree
    t.index ["name"], name: "index_categories_on_name", unique: true, using: :btree
  end

  create_table "chat_users", force: :cascade do |t|
    t.integer  "chat_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id", "user_id"], name: "index_chat_users_on_chat_id_and_user_id", unique: true, using: :btree
    t.index ["chat_id"], name: "index_chat_users_on_chat_id", using: :btree
    t.index ["user_id", "chat_id"], name: "index_chat_users_on_user_id_and_chat_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_chat_users_on_user_id", using: :btree
  end

  create_table "chats", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comment_translations", force: :cascade do |t|
    t.string   "locale"
    t.text     "body"
    t.integer  "comment_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "language_id"
    t.index ["comment_id"], name: "index_comment_translations_on_comment_id", using: :btree
    t.index ["language_id"], name: "index_comment_translations_on_language_id", using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.text     "body"
    t.string   "commentable_type"
    t.integer  "commentable_id"
    t.integer  "owner_user_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "language_id"
    t.boolean  "hidden",           default: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree
    t.index ["language_id"], name: "index_comments_on_language_id", using: :btree
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.string   "cin"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "frilans_finans_id"
    t.string   "website"
    t.string   "email"
    t.string   "street"
    t.string   "zip"
    t.string   "city"
    t.string   "phone"
    t.string   "billing_email"
    t.index ["cin"], name: "index_companies_on_cin", unique: true, using: :btree
    t.index ["frilans_finans_id"], name: "index_companies_on_frilans_finans_id", unique: true, using: :btree
  end

  create_table "company_images", force: :cascade do |t|
    t.datetime "one_time_token_expires_at"
    t.string   "one_time_token"
    t.integer  "company_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.index ["company_id"], name: "index_company_images_on_company_id", using: :btree
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "currencies", force: :cascade do |t|
    t.string   "currency_code"
    t.integer  "frilans_finans_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["frilans_finans_id"], name: "index_currencies_on_frilans_finans_id", unique: true, using: :btree
  end

  create_table "faq_translations", force: :cascade do |t|
    t.string   "locale"
    t.text     "question"
    t.text     "answer"
    t.integer  "language_id"
    t.integer  "faq_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["faq_id"], name: "index_faq_translations_on_faq_id", using: :btree
    t.index ["language_id"], name: "index_faq_translations_on_language_id", using: :btree
  end

  create_table "faqs", force: :cascade do |t|
    t.text     "answer"
    t.text     "question"
    t.integer  "language_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["language_id"], name: "index_faqs_on_language_id", using: :btree
  end

  create_table "frilans_finans_api_logs", force: :cascade do |t|
    t.integer  "status"
    t.string   "status_name"
    t.string   "verb"
    t.text     "params"
    t.text     "response_body"
    t.string   "uri",           limit: 2083
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "frilans_finans_invoices", force: :cascade do |t|
    t.integer  "frilans_finans_id"
    t.integer  "job_user_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.boolean  "activated",          default: false
    t.boolean  "ff_pre_report",      default: true
    t.float    "ff_amount"
    t.float    "ff_gross_salary"
    t.float    "ff_net_salary"
    t.integer  "ff_payment_status"
    t.integer  "ff_approval_status"
    t.integer  "ff_status"
    t.datetime "ff_sent_at"
    t.boolean  "express_payment",    default: false
    t.datetime "ff_last_synced_at"
    t.index ["job_user_id"], name: "index_frilans_finans_invoices_on_job_user_id", using: :btree
  end

  create_table "frilans_finans_terms", force: :cascade do |t|
    t.text     "body"
    t.boolean  "company",    default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "hourly_pays", force: :cascade do |t|
    t.boolean  "active",       default: false
    t.string   "currency",     default: "SEK"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "gross_salary"
  end

  create_table "invoices", force: :cascade do |t|
    t.integer  "job_user_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "frilans_finans_invoice_id"
    t.index ["frilans_finans_invoice_id"], name: "index_invoices_on_frilans_finans_invoice_id", using: :btree
    t.index ["job_user_id"], name: "index_invoices_on_job_user_id", using: :btree
    t.index ["job_user_id"], name: "index_invoices_on_job_user_id_uniq", unique: true, using: :btree
  end

  create_table "job_requests", force: :cascade do |t|
    t.string   "company_name"
    t.string   "contact_string"
    t.string   "assignment"
    t.string   "job_scope"
    t.string   "job_specification"
    t.string   "language_requirements"
    t.string   "job_at_date"
    t.string   "responsible"
    t.string   "suitable_candidates"
    t.string   "comment"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "short_name"
    t.boolean  "finished",              default: false
  end

  create_table "job_skills", force: :cascade do |t|
    t.integer  "job_id"
    t.integer  "skill_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id", "skill_id"], name: "index_job_skills_on_job_id_and_skill_id", unique: true, using: :btree
    t.index ["job_id"], name: "index_job_skills_on_job_id", using: :btree
    t.index ["skill_id", "job_id"], name: "index_job_skills_on_skill_id_and_job_id", unique: true, using: :btree
    t.index ["skill_id"], name: "index_job_skills_on_skill_id", using: :btree
  end

  create_table "job_translations", force: :cascade do |t|
    t.string   "locale"
    t.string   "short_description"
    t.string   "name"
    t.text     "description"
    t.integer  "job_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "language_id"
    t.index ["job_id"], name: "index_job_translations_on_job_id", using: :btree
    t.index ["language_id"], name: "index_job_translations_on_language_id", using: :btree
  end

  create_table "job_user_translations", force: :cascade do |t|
    t.string   "locale"
    t.text     "apply_message"
    t.integer  "job_user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "language_id"
    t.index ["job_user_id"], name: "index_job_user_translations_on_job_user_id", using: :btree
    t.index ["language_id"], name: "index_job_user_translations_on_language_id", using: :btree
  end

  create_table "job_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "job_id"
    t.boolean  "accepted",      default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "will_perform",  default: false
    t.datetime "accepted_at"
    t.boolean  "performed",     default: false
    t.text     "apply_message"
    t.integer  "language_id"
    t.index ["job_id", "user_id"], name: "index_job_users_on_job_id_and_user_id", unique: true, using: :btree
    t.index ["job_id"], name: "index_job_users_on_job_id", using: :btree
    t.index ["language_id"], name: "index_job_users_on_language_id", using: :btree
    t.index ["user_id", "job_id"], name: "index_job_users_on_user_id_and_job_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_job_users_on_user_id", using: :btree
  end

  create_table "jobs", force: :cascade do |t|
    t.text     "description"
    t.datetime "job_date"
    t.float    "hours"
    t.string   "name"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "owner_user_id"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "language_id"
    t.string   "street"
    t.string   "zip"
    t.float    "zip_latitude"
    t.float    "zip_longitude"
    t.boolean  "hidden",            default: false
    t.integer  "category_id"
    t.integer  "hourly_pay_id"
    t.boolean  "verified",          default: false
    t.datetime "job_end_date"
    t.boolean  "cancelled",         default: false
    t.boolean  "filled",            default: false
    t.string   "short_description"
    t.boolean  "featured",          default: false
    t.boolean  "upcoming",          default: false
    t.index ["category_id"], name: "index_jobs_on_category_id", using: :btree
    t.index ["hourly_pay_id"], name: "index_jobs_on_hourly_pay_id", using: :btree
    t.index ["language_id"], name: "index_jobs_on_language_id", using: :btree
  end

  create_table "languages", force: :cascade do |t|
    t.string   "lang_code"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "en_name"
    t.string   "direction"
    t.string   "local_name"
    t.boolean  "system_language",     default: false
    t.string   "sv_name"
    t.string   "ar_name"
    t.string   "fa_name"
    t.string   "fa_af_name"
    t.string   "ku_name"
    t.string   "ti_name"
    t.string   "ps_name"
    t.boolean  "machine_translation", default: false
    t.index ["lang_code"], name: "index_languages_on_lang_code", unique: true, using: :btree
  end

  create_table "message_translations", force: :cascade do |t|
    t.string   "locale"
    t.text     "body"
    t.integer  "message_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "language_id"
    t.index ["language_id"], name: "index_message_translations_on_language_id", using: :btree
    t.index ["message_id"], name: "index_message_translations_on_message_id", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "chat_id"
    t.integer  "author_id"
    t.integer  "integer"
    t.integer  "language_id"
    t.text     "body"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["chat_id"], name: "index_messages_on_chat_id", using: :btree
    t.index ["language_id"], name: "index_messages_on_language_id", using: :btree
  end

  create_table "ratings", force: :cascade do |t|
    t.integer  "from_user_id"
    t.integer  "to_user_id"
    t.integer  "job_id"
    t.integer  "score",        null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["job_id", "from_user_id"], name: "index_ratings_on_job_id_and_from_user_id", unique: true, using: :btree
    t.index ["job_id", "to_user_id"], name: "index_ratings_on_job_id_and_to_user_id", unique: true, using: :btree
  end

  create_table "skills", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "language_id"
    t.boolean  "internal",    default: false
    t.index ["language_id"], name: "index_skills_on_language_id", using: :btree
    t.index ["name"], name: "index_skills_on_name", unique: true, using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.string   "color"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "terms_agreement_consents", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "job_id"
    t.integer  "terms_agreement_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["job_id", "user_id"], name: "index_terms_agreement_consents_on_job_id_and_user_id", unique: true, using: :btree
    t.index ["job_id"], name: "index_terms_agreement_consents_on_job_id", using: :btree
    t.index ["terms_agreement_id"], name: "index_terms_agreement_consents_on_terms_agreement_id", using: :btree
    t.index ["user_id", "job_id"], name: "index_terms_agreement_consents_on_user_id_and_job_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_terms_agreement_consents_on_user_id", using: :btree
  end

  create_table "terms_agreements", force: :cascade do |t|
    t.string   "version"
    t.string   "url",                    limit: 2000
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "frilans_finans_term_id"
    t.index ["frilans_finans_term_id"], name: "index_terms_agreements_on_frilans_finans_term_id", using: :btree
    t.index ["version"], name: "index_terms_agreements_on_version", unique: true, using: :btree
  end

  create_table "tokens", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "token"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_tokens_on_token", using: :btree
    t.index ["user_id"], name: "index_tokens_on_user_id", using: :btree
  end

  create_table "user_images", force: :cascade do |t|
    t.datetime "one_time_token_expires_at"
    t.string   "one_time_token"
    t.integer  "user_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "category"
    t.index ["user_id"], name: "index_user_images_on_user_id", using: :btree
  end

  create_table "user_languages", force: :cascade do |t|
    t.integer  "language_id"
    t.integer  "user_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "proficiency"
    t.integer  "proficiency_by_admin"
    t.index ["language_id", "user_id"], name: "index_user_languages_on_language_id_and_user_id", unique: true, using: :btree
    t.index ["language_id"], name: "index_user_languages_on_language_id", using: :btree
    t.index ["user_id", "language_id"], name: "index_user_languages_on_user_id_and_language_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_user_languages_on_user_id", using: :btree
  end

  create_table "user_skills", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "skill_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "proficiency"
    t.integer  "proficiency_by_admin"
    t.index ["skill_id", "user_id"], name: "index_user_skills_on_skill_id_and_user_id", unique: true, using: :btree
    t.index ["skill_id"], name: "index_user_skills_on_skill_id", using: :btree
    t.index ["user_id", "skill_id"], name: "index_user_skills_on_user_id_and_skill_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_user_skills_on_user_id", using: :btree
  end

  create_table "user_tags", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_user_tags_on_tag_id", using: :btree
    t.index ["user_id"], name: "index_user_tags_on_user_id", using: :btree
  end

  create_table "user_translations", force: :cascade do |t|
    t.string   "locale"
    t.text     "description"
    t.text     "job_experience"
    t.text     "education"
    t.text     "competence_text"
    t.integer  "user_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "language_id"
    t.index ["language_id"], name: "index_user_translations_on_language_id", using: :btree
    t.index ["user_id"], name: "index_user_translations_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "phone"
    t.text     "description"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "language_id"
    t.boolean  "anonymized",                     default: false
    t.string   "password_hash"
    t.string   "password_salt"
    t.boolean  "admin",                          default: false
    t.string   "street"
    t.string   "zip"
    t.float    "zip_latitude"
    t.float    "zip_longitude"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "ssn"
    t.integer  "company_id"
    t.boolean  "banned",                         default: false
    t.text     "job_experience"
    t.text     "education"
    t.string   "one_time_token"
    t.datetime "one_time_token_expires_at"
    t.integer  "ignored_notifications_mask"
    t.integer  "frilans_finans_id"
    t.boolean  "frilans_finans_payment_details", default: false
    t.text     "competence_text"
    t.integer  "current_status"
    t.integer  "at_und"
    t.date     "arrived_at"
    t.string   "country_of_origin"
    t.boolean  "managed",                        default: false
    t.string   "account_clearing_number"
    t.string   "account_number"
    t.boolean  "verified",                       default: false
    t.string   "skype_username"
    t.index ["company_id"], name: "index_users_on_company_id", using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["frilans_finans_id"], name: "index_users_on_frilans_finans_id", unique: true, using: :btree
    t.index ["language_id"], name: "index_users_on_language_id", using: :btree
    t.index ["one_time_token"], name: "index_users_on_one_time_token", unique: true, using: :btree
  end

  add_foreign_key "blazer_audits", "blazer_queries", column: "query_id", name: "blazer_audits_query_id_fk"
  add_foreign_key "blazer_checks", "blazer_queries", column: "query_id", name: "blazer_checks_query_id_fk"
  add_foreign_key "blazer_dashboard_queries", "blazer_dashboards", column: "dashboard_id", name: "blazer_dashboard_queries_dashboard_id_fk"
  add_foreign_key "blazer_dashboard_queries", "blazer_queries", column: "query_id", name: "blazer_dashboard_queries_query_id_fk"
  add_foreign_key "blazer_queries", "users", column: "creator_id", name: "blazer_queries_creator_id_fk"
  add_foreign_key "chat_users", "chats"
  add_foreign_key "chat_users", "users"
  add_foreign_key "comment_translations", "comments"
  add_foreign_key "comment_translations", "languages"
  add_foreign_key "comments", "languages"
  add_foreign_key "comments", "users", column: "owner_user_id", name: "comments_owner_user_id_fk"
  add_foreign_key "company_images", "companies"
  add_foreign_key "faq_translations", "faqs"
  add_foreign_key "faq_translations", "languages"
  add_foreign_key "faqs", "languages"
  add_foreign_key "frilans_finans_invoices", "job_users"
  add_foreign_key "invoices", "frilans_finans_invoices"
  add_foreign_key "invoices", "job_users"
  add_foreign_key "job_skills", "jobs"
  add_foreign_key "job_skills", "skills"
  add_foreign_key "job_translations", "jobs"
  add_foreign_key "job_translations", "languages"
  add_foreign_key "job_user_translations", "job_users"
  add_foreign_key "job_user_translations", "languages"
  add_foreign_key "job_users", "jobs"
  add_foreign_key "job_users", "languages"
  add_foreign_key "job_users", "users"
  add_foreign_key "jobs", "categories"
  add_foreign_key "jobs", "hourly_pays"
  add_foreign_key "jobs", "languages"
  add_foreign_key "jobs", "users", column: "owner_user_id", name: "jobs_owner_user_id_fk"
  add_foreign_key "message_translations", "languages"
  add_foreign_key "message_translations", "messages"
  add_foreign_key "messages", "chats"
  add_foreign_key "messages", "languages"
  add_foreign_key "messages", "users", column: "author_id", name: "messages_author_id_fk"
  add_foreign_key "ratings", "jobs", name: "ratings_job_id_fk"
  add_foreign_key "ratings", "users", column: "from_user_id", name: "ratings_from_user_id_fk"
  add_foreign_key "ratings", "users", column: "to_user_id", name: "ratings_to_user_id_fk"
  add_foreign_key "skills", "languages"
  add_foreign_key "terms_agreement_consents", "jobs"
  add_foreign_key "terms_agreement_consents", "terms_agreements"
  add_foreign_key "terms_agreement_consents", "users"
  add_foreign_key "terms_agreements", "frilans_finans_terms"
  add_foreign_key "tokens", "users"
  add_foreign_key "user_images", "users"
  add_foreign_key "user_languages", "languages"
  add_foreign_key "user_languages", "users"
  add_foreign_key "user_skills", "skills"
  add_foreign_key "user_skills", "users"
  add_foreign_key "user_tags", "tags"
  add_foreign_key "user_tags", "users"
  add_foreign_key "user_translations", "languages"
  add_foreign_key "user_translations", "users"
  add_foreign_key "users", "companies"
  add_foreign_key "users", "languages"
end
