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

ActiveRecord::Schema.define(version: 20171020113203) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "pg_stat_statements"
  enable_extension "unaccent"

  create_table "active_admin_comments", id: :serial, force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_id", null: false
    t.string "resource_type", null: false
    t.integer "author_id"
    t.string "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "addresses", force: :cascade do |t|
    t.string "street1"
    t.string "street2"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.string "municipality"
    t.string "country_code"
    t.string "uuid", limit: 36
    t.decimal "latitude", precision: 15, scale: 10
    t.decimal "longitude", precision: 15, scale: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uuid"], name: "index_addresses_on_uuid"
  end

  create_table "ahoy_events", id: :serial, force: :cascade do |t|
    t.integer "visit_id"
    t.integer "user_id"
    t.string "name"
    t.jsonb "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["user_id", "name"], name: "index_ahoy_events_on_user_id_and_name"
    t.index ["visit_id", "name"], name: "index_ahoy_events_on_visit_id_and_name"
  end

  create_table "arbetsformedlingen_ad_logs", id: :serial, force: :cascade do |t|
    t.integer "arbetsformedlingen_ad_id"
    t.json "response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["arbetsformedlingen_ad_id"], name: "index_arbetsformedlingen_ad_logs_on_arbetsformedlingen_ad_id"
  end

  create_table "arbetsformedlingen_ads", id: :serial, force: :cascade do |t|
    t.integer "job_id"
    t.boolean "published", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "occupation"
    t.index ["job_id"], name: "index_arbetsformedlingen_ads_on_job_id"
  end

  create_table "blazer_audits", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "query_id"
    t.text "statement"
    t.string "data_source"
    t.datetime "created_at"
  end

  create_table "blazer_checks", id: :serial, force: :cascade do |t|
    t.integer "query_id"
    t.string "state"
    t.text "emails"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blazer_dashboard_queries", id: :serial, force: :cascade do |t|
    t.integer "dashboard_id"
    t.integer "query_id"
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blazer_dashboards", id: :serial, force: :cascade do |t|
    t.text "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blazer_queries", id: :serial, force: :cascade do |t|
    t.integer "creator_id"
    t.string "name"
    t.text "description"
    t.text "statement"
    t.string "data_source"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "frilans_finans_id"
    t.integer "insurance_status"
    t.integer "ssyk"
    t.index ["frilans_finans_id"], name: "index_categories_on_frilans_finans_id", unique: true
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "chat_users", id: :serial, force: :cascade do |t|
    t.integer "chat_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id", "user_id"], name: "index_chat_users_on_chat_id_and_user_id", unique: true
    t.index ["chat_id"], name: "index_chat_users_on_chat_id"
    t.index ["user_id", "chat_id"], name: "index_chat_users_on_user_id_and_chat_id", unique: true
    t.index ["user_id"], name: "index_chat_users_on_user_id"
  end

  create_table "chats", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comment_translations", id: :serial, force: :cascade do |t|
    t.string "locale"
    t.text "body"
    t.integer "comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "language_id"
    t.index ["comment_id"], name: "index_comment_translations_on_comment_id"
    t.index ["language_id"], name: "index_comment_translations_on_language_id"
  end

  create_table "comments", id: :serial, force: :cascade do |t|
    t.text "body"
    t.integer "commentable_id"
    t.string "commentable_type"
    t.integer "owner_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "language_id"
    t.boolean "hidden", default: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
    t.index ["language_id"], name: "index_comments_on_language_id"
  end

  create_table "communication_template_translations", id: :serial, force: :cascade do |t|
    t.string "subject"
    t.text "body"
    t.integer "language_id"
    t.string "locale"
    t.integer "communication_template_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["communication_template_id"], name: "index_comm_template_translations_on_comm_template_id"
    t.index ["language_id"], name: "index_communication_template_translations_on_language_id"
  end

  create_table "communication_templates", id: :serial, force: :cascade do |t|
    t.integer "language_id"
    t.string "category"
    t.string "subject"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["language_id"], name: "index_communication_templates_on_language_id"
  end

  create_table "companies", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "cin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "frilans_finans_id"
    t.string "website"
    t.string "email"
    t.string "street"
    t.string "zip"
    t.string "city"
    t.string "phone"
    t.string "billing_email"
    t.string "municipality"
    t.boolean "staffing_agency", default: false
    t.string "display_name"
    t.integer "sales_user_id"
    t.index ["cin"], name: "index_companies_on_cin", unique: true
    t.index ["frilans_finans_id"], name: "index_companies_on_frilans_finans_id", unique: true
  end

  create_table "company_images", id: :serial, force: :cascade do |t|
    t.datetime "one_time_token_expires_at"
    t.string "one_time_token"
    t.integer "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.index ["company_id"], name: "index_company_images_on_company_id"
  end

  create_table "company_industries", force: :cascade do |t|
    t.bigint "company_id"
    t.bigint "industry_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_company_industries_on_company_id"
    t.index ["industry_id"], name: "index_company_industries_on_industry_id"
  end

  create_table "company_translations", force: :cascade do |t|
    t.string "locale"
    t.string "short_description"
    t.text "description"
    t.bigint "language_id"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_company_translations_on_company_id"
    t.index ["language_id"], name: "index_company_translations_on_language_id"
  end

  create_table "contacts", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "currencies", id: :serial, force: :cascade do |t|
    t.string "currency_code"
    t.integer "frilans_finans_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["frilans_finans_id"], name: "index_currencies_on_frilans_finans_id", unique: true
  end

  create_table "digest_subscribers", force: :cascade do |t|
    t.string "email"
    t.string "uuid", limit: 36
    t.datetime "deleted_at"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_digest_subscribers_on_user_id"
    t.index ["uuid"], name: "index_digest_subscribers_on_uuid", unique: true
  end

  create_table "documents", id: :serial, force: :cascade do |t|
    t.string "one_time_token"
    t.datetime "one_time_token_expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "document_file_name"
    t.string "document_content_type"
    t.integer "document_file_size"
    t.datetime "document_updated_at"
    t.text "text_content"
  end

  create_table "faq_translations", id: :serial, force: :cascade do |t|
    t.string "locale"
    t.text "question"
    t.text "answer"
    t.integer "language_id"
    t.integer "faq_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["faq_id"], name: "index_faq_translations_on_faq_id"
    t.index ["language_id"], name: "index_faq_translations_on_language_id"
  end

  create_table "faqs", id: :serial, force: :cascade do |t|
    t.text "answer"
    t.text "question"
    t.integer "language_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["language_id"], name: "index_faqs_on_language_id"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "job_id"
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_feedbacks_on_job_id"
    t.index ["user_id"], name: "index_feedbacks_on_user_id"
  end

  create_table "filter_users", id: :serial, force: :cascade do |t|
    t.integer "filter_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["filter_id"], name: "index_filter_users_on_filter_id"
    t.index ["user_id"], name: "index_filter_users_on_user_id"
  end

  create_table "filters", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "frilans_finans_api_logs", id: :serial, force: :cascade do |t|
    t.integer "status"
    t.string "status_name"
    t.string "verb"
    t.text "params"
    t.text "response_body"
    t.string "uri", limit: 2083
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "frilans_finans_invoices", id: :serial, force: :cascade do |t|
    t.integer "frilans_finans_id"
    t.integer "job_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "activated", default: false
    t.boolean "ff_pre_report", default: true
    t.float "ff_amount"
    t.float "ff_gross_salary"
    t.float "ff_net_salary"
    t.integer "ff_payment_status"
    t.integer "ff_approval_status"
    t.integer "ff_status"
    t.datetime "ff_sent_at"
    t.boolean "express_payment", default: false
    t.datetime "ff_last_synced_at"
    t.integer "ff_invoice_number"
    t.index ["job_user_id"], name: "index_frilans_finans_invoices_on_job_user_id"
  end

  create_table "frilans_finans_terms", id: :serial, force: :cascade do |t|
    t.text "body"
    t.boolean "company", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "guide_section_article_translations", force: :cascade do |t|
    t.bigint "language_id"
    t.integer "guide_section_article_id"
    t.string "locale"
    t.string "title"
    t.string "slug"
    t.string "short_description"
    t.string "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["language_id"], name: "index_guide_section_article_translations_on_language_id"
  end

  create_table "guide_section_articles", force: :cascade do |t|
    t.bigint "language_id"
    t.bigint "guide_section_id"
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guide_section_id"], name: "index_guide_section_articles_on_guide_section_id"
    t.index ["language_id"], name: "index_guide_section_articles_on_language_id"
  end

  create_table "guide_section_translations", force: :cascade do |t|
    t.string "locale"
    t.string "title"
    t.string "slug"
    t.string "short_description"
    t.bigint "guide_section_id"
    t.bigint "language_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guide_section_id"], name: "index_guide_section_translations_on_guide_section_id"
    t.index ["language_id"], name: "index_guide_section_translations_on_language_id"
  end

  create_table "guide_sections", force: :cascade do |t|
    t.integer "order"
    t.bigint "language_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["language_id"], name: "index_guide_sections_on_language_id"
  end

  create_table "hourly_pays", id: :serial, force: :cascade do |t|
    t.boolean "active", default: false
    t.string "currency", default: "SEK"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "gross_salary"
  end

  create_table "industries", force: :cascade do |t|
    t.string "name"
    t.string "ancestry"
    t.bigint "language_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ancestry"], name: "index_industries_on_ancestry"
    t.index ["language_id"], name: "index_industries_on_language_id"
  end

  create_table "industry_translations", force: :cascade do |t|
    t.string "name"
    t.bigint "industry_id"
    t.bigint "language_id"
    t.string "locale"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["industry_id"], name: "index_industry_translations_on_industry_id"
    t.index ["language_id"], name: "index_industry_translations_on_language_id"
  end

  create_table "interest_filters", id: :serial, force: :cascade do |t|
    t.integer "filter_id"
    t.integer "interest_id"
    t.integer "level"
    t.integer "level_by_admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["filter_id"], name: "index_interest_filters_on_filter_id"
    t.index ["interest_id"], name: "index_interest_filters_on_interest_id"
  end

  create_table "interest_translations", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "locale"
    t.integer "language_id"
    t.integer "interest_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["interest_id"], name: "index_interest_translations_on_interest_id"
    t.index ["language_id"], name: "index_interest_translations_on_language_id"
  end

  create_table "interests", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "language_id"
    t.boolean "internal", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["language_id"], name: "index_interests_on_language_id"
  end

  create_table "invoices", id: :serial, force: :cascade do |t|
    t.integer "job_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "frilans_finans_invoice_id"
    t.index ["frilans_finans_invoice_id"], name: "index_invoices_on_frilans_finans_invoice_id"
    t.index ["job_user_id"], name: "index_invoices_on_job_user_id"
    t.index ["job_user_id"], name: "index_invoices_on_job_user_id_uniq", unique: true
  end

  create_table "job_digest_addresses", force: :cascade do |t|
    t.bigint "job_digest_id"
    t.bigint "address_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_job_digest_addresses_on_address_id"
    t.index ["job_digest_id"], name: "index_job_digest_addresses_on_job_digest_id"
  end

  create_table "job_digest_occupations", force: :cascade do |t|
    t.bigint "job_digest_id"
    t.bigint "occupation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_digest_id"], name: "index_job_digest_occupations_on_job_digest_id"
    t.index ["occupation_id"], name: "index_job_digest_occupations_on_occupation_id"
  end

  create_table "job_digests", force: :cascade do |t|
    t.integer "notification_frequency"
    t.float "max_distance"
    t.string "locale", limit: 10
    t.datetime "deleted_at"
    t.bigint "digest_subscriber_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["digest_subscriber_id"], name: "index_job_digests_on_digest_subscriber_id"
  end

  create_table "job_languages", id: :serial, force: :cascade do |t|
    t.integer "job_id"
    t.integer "language_id"
    t.integer "proficiency"
    t.integer "proficiency_by_admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_job_languages_on_job_id"
    t.index ["language_id"], name: "index_job_languages_on_language_id"
  end

  create_table "job_occupations", force: :cascade do |t|
    t.bigint "job_id"
    t.bigint "occupation_id"
    t.integer "years_of_experience"
    t.integer "importance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_job_occupations_on_job_id"
    t.index ["occupation_id"], name: "index_job_occupations_on_occupation_id"
  end

  create_table "job_requests", id: :serial, force: :cascade do |t|
    t.string "company_name"
    t.string "contact_string"
    t.string "assignment"
    t.string "job_scope"
    t.string "job_specification"
    t.string "language_requirements"
    t.string "job_at_date"
    t.string "responsible"
    t.string "suitable_candidates"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "short_name"
    t.boolean "finished", default: false
    t.boolean "cancelled", default: false
    t.boolean "draft_sent", default: false
    t.boolean "signed_by_customer", default: false
    t.string "requirements"
    t.string "hourly_pay"
    t.string "company_org_no"
    t.string "company_email"
    t.string "company_phone"
    t.string "company_address"
    t.integer "company_id"
    t.integer "delivery_user_id"
    t.integer "sales_user_id"
    t.index ["company_id"], name: "index_job_requests_on_company_id"
  end

  create_table "job_skills", id: :serial, force: :cascade do |t|
    t.integer "job_id"
    t.integer "skill_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "proficiency"
    t.integer "proficiency_by_admin"
    t.index ["job_id", "skill_id"], name: "index_job_skills_on_job_id_and_skill_id", unique: true
    t.index ["job_id"], name: "index_job_skills_on_job_id"
    t.index ["skill_id", "job_id"], name: "index_job_skills_on_skill_id_and_job_id", unique: true
    t.index ["skill_id"], name: "index_job_skills_on_skill_id"
  end

  create_table "job_translations", id: :serial, force: :cascade do |t|
    t.string "locale"
    t.string "short_description"
    t.string "name"
    t.text "description"
    t.integer "job_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "language_id"
    t.text "tasks_description"
    t.text "applicant_description"
    t.text "requirements_description"
    t.index ["job_id"], name: "index_job_translations_on_job_id"
    t.index ["language_id"], name: "index_job_translations_on_language_id"
  end

  create_table "job_user_translations", id: :serial, force: :cascade do |t|
    t.string "locale"
    t.text "apply_message"
    t.integer "job_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "language_id"
    t.index ["job_user_id"], name: "index_job_user_translations_on_job_user_id"
    t.index ["language_id"], name: "index_job_user_translations_on_language_id"
  end

  create_table "job_users", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "job_id"
    t.boolean "accepted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "will_perform", default: false
    t.datetime "accepted_at"
    t.boolean "performed", default: false
    t.text "apply_message"
    t.integer "language_id"
    t.boolean "application_withdrawn", default: false
    t.boolean "shortlisted", default: false
    t.boolean "rejected", default: false
    t.string "http_referrer", limit: 2083
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_campaign"
    t.string "utm_term"
    t.string "utm_content"
    t.index ["job_id", "user_id"], name: "index_job_users_on_job_id_and_user_id", unique: true
    t.index ["job_id"], name: "index_job_users_on_job_id"
    t.index ["language_id"], name: "index_job_users_on_language_id"
    t.index ["user_id", "job_id"], name: "index_job_users_on_user_id_and_job_id", unique: true
    t.index ["user_id"], name: "index_job_users_on_user_id"
  end

  create_table "jobs", id: :serial, force: :cascade do |t|
    t.text "description"
    t.datetime "job_date"
    t.float "hours"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "owner_user_id"
    t.float "latitude"
    t.float "longitude"
    t.integer "language_id"
    t.string "street"
    t.string "zip"
    t.float "zip_latitude"
    t.float "zip_longitude"
    t.boolean "hidden", default: false
    t.integer "category_id"
    t.integer "hourly_pay_id"
    t.boolean "verified", default: false
    t.datetime "job_end_date"
    t.boolean "cancelled", default: false
    t.string "short_description"
    t.boolean "featured", default: false
    t.boolean "upcoming", default: false
    t.integer "company_contact_user_id"
    t.integer "just_arrived_contact_user_id"
    t.string "city"
    t.boolean "staffing_job", default: false
    t.boolean "direct_recruitment_job", default: false
    t.integer "order_id"
    t.string "municipality"
    t.integer "number_to_fill", default: 1
    t.boolean "full_time", default: false
    t.string "swedish_drivers_license"
    t.boolean "car_required", default: false
    t.integer "salary_type", default: 1
    t.boolean "publish_on_linkedin", default: false
    t.boolean "publish_on_blocketjobb", default: false
    t.datetime "last_application_at"
    t.string "blocketjobb_category"
    t.datetime "publish_at"
    t.datetime "unpublish_at"
    t.text "tasks_description"
    t.text "applicant_description"
    t.text "requirements_description"
    t.string "preview_key"
    t.decimal "customer_hourly_price"
    t.text "invoice_comment"
    t.boolean "publish_on_metrojobb", default: false
    t.string "metrojobb_category"
    t.integer "staffing_company_id"
    t.boolean "cloned", default: false
    t.datetime "filled_at"
    t.index ["category_id"], name: "index_jobs_on_category_id"
    t.index ["hourly_pay_id"], name: "index_jobs_on_hourly_pay_id"
    t.index ["language_id"], name: "index_jobs_on_language_id"
    t.index ["order_id"], name: "index_jobs_on_order_id"
    t.index ["staffing_company_id"], name: "index_jobs_on_staffing_company_id"
  end

  create_table "language_filters", id: :serial, force: :cascade do |t|
    t.integer "filter_id"
    t.integer "language_id"
    t.integer "proficiency"
    t.integer "proficiency_by_admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["filter_id"], name: "index_language_filters_on_filter_id"
    t.index ["language_id"], name: "index_language_filters_on_language_id"
  end

  create_table "languages", id: :serial, force: :cascade do |t|
    t.string "lang_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "en_name"
    t.string "direction"
    t.string "local_name"
    t.boolean "system_language", default: false
    t.string "sv_name"
    t.string "ar_name"
    t.string "fa_name"
    t.string "fa_af_name"
    t.string "ku_name"
    t.string "ti_name"
    t.string "ps_name"
    t.boolean "machine_translation", default: false
    t.index ["lang_code"], name: "index_languages_on_lang_code", unique: true
  end

  create_table "message_translations", id: :serial, force: :cascade do |t|
    t.string "locale"
    t.text "body"
    t.integer "message_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "language_id"
    t.index ["language_id"], name: "index_message_translations_on_language_id"
    t.index ["message_id"], name: "index_message_translations_on_message_id"
  end

  create_table "messages", id: :serial, force: :cascade do |t|
    t.integer "chat_id"
    t.integer "author_id"
    t.integer "integer"
    t.integer "language_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_messages_on_chat_id"
    t.index ["language_id"], name: "index_messages_on_language_id"
  end

  create_table "occupation_translations", force: :cascade do |t|
    t.string "name"
    t.bigint "occupation_id"
    t.bigint "language_id"
    t.string "locale"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["language_id"], name: "index_occupation_translations_on_language_id"
    t.index ["occupation_id"], name: "index_occupation_translations_on_occupation_id"
  end

  create_table "occupations", force: :cascade do |t|
    t.string "name"
    t.string "ancestry"
    t.bigint "language_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ancestry"], name: "index_occupations_on_ancestry"
    t.index ["language_id"], name: "index_occupations_on_language_id"
  end

  create_table "order_documents", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "document_id"
    t.integer "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_id"], name: "index_order_documents_on_document_id"
    t.index ["order_id"], name: "index_order_documents_on_order_id"
  end

  create_table "order_values", force: :cascade do |t|
    t.bigint "order_id"
    t.integer "previous_order_value_id"
    t.text "change_comment"
    t.integer "change_reason_category"
    t.decimal "sold_hourly_salary"
    t.decimal "sold_hourly_price"
    t.decimal "sold_hours_per_month"
    t.decimal "sold_number_of_months"
    t.decimal "total_sold"
    t.decimal "total_filled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "changed_by_user_id"
    t.index ["order_id"], name: "index_order_values_on_order_id"
  end

  create_table "orders", id: :serial, force: :cascade do |t|
    t.integer "job_request_id"
    t.decimal "invoice_hourly_pay_rate"
    t.decimal "hourly_pay_rate"
    t.decimal "hours"
    t.boolean "lost", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "filled_hourly_pay_rate"
    t.decimal "filled_invoice_hourly_pay_rate"
    t.decimal "filled_hours"
    t.string "name"
    t.integer "category"
    t.bigint "company_id"
    t.integer "sales_user_id"
    t.integer "delivery_user_id"
    t.integer "previous_order_id"
    t.index ["company_id"], name: "index_orders_on_company_id"
    t.index ["delivery_user_id"], name: "index_orders_on_delivery_user_id"
    t.index ["job_request_id"], name: "index_orders_on_job_request_id"
    t.index ["previous_order_id"], name: "index_orders_on_previous_order_id"
    t.index ["sales_user_id"], name: "index_orders_on_sales_user_id"
  end

  create_table "ratings", id: :serial, force: :cascade do |t|
    t.integer "from_user_id"
    t.integer "to_user_id"
    t.integer "job_id"
    t.integer "score", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id", "from_user_id"], name: "index_ratings_on_job_id_and_from_user_id", unique: true
    t.index ["job_id", "to_user_id"], name: "index_ratings_on_job_id_and_to_user_id", unique: true
  end

  create_table "received_emails", id: :serial, force: :cascade do |t|
    t.string "from_address"
    t.string "to_address"
    t.string "subject"
    t.text "text_body"
    t.text "html_body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "received_texts", id: :serial, force: :cascade do |t|
    t.string "from_number"
    t.string "to_number"
    t.string "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "skill_filters", id: :serial, force: :cascade do |t|
    t.integer "filter_id"
    t.integer "skill_id"
    t.integer "proficiency"
    t.integer "proficiency_by_admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["filter_id"], name: "index_skill_filters_on_filter_id"
    t.index ["skill_id"], name: "index_skill_filters_on_skill_id"
  end

  create_table "skill_translations", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "locale"
    t.integer "language_id"
    t.integer "skill_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["language_id"], name: "index_skill_translations_on_language_id"
    t.index ["skill_id"], name: "index_skill_translations_on_skill_id"
  end

  create_table "skills", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "language_id"
    t.boolean "internal", default: false
    t.string "color"
    t.boolean "high_priority", default: false
    t.index ["language_id"], name: "index_skills_on_language_id"
    t.index ["name"], name: "index_skills_on_name", unique: true
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "color"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "terms_agreement_consents", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "job_id"
    t.integer "terms_agreement_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id", "user_id"], name: "index_terms_agreement_consents_on_job_id_and_user_id", unique: true
    t.index ["job_id"], name: "index_terms_agreement_consents_on_job_id"
    t.index ["terms_agreement_id"], name: "index_terms_agreement_consents_on_terms_agreement_id"
    t.index ["user_id", "job_id"], name: "index_terms_agreement_consents_on_user_id_and_job_id", unique: true
    t.index ["user_id"], name: "index_terms_agreement_consents_on_user_id"
  end

  create_table "terms_agreements", id: :serial, force: :cascade do |t|
    t.string "version"
    t.string "url", limit: 2000
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "frilans_finans_term_id"
    t.index ["frilans_finans_term_id"], name: "index_terms_agreements_on_frilans_finans_term_id"
    t.index ["version"], name: "index_terms_agreements_on_version", unique: true
  end

  create_table "tokens", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "token"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_tokens_on_token"
    t.index ["user_id"], name: "index_tokens_on_user_id"
  end

  create_table "user_documents", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "document_id"
    t.integer "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_id"], name: "index_user_documents_on_document_id"
    t.index ["user_id"], name: "index_user_documents_on_user_id"
  end

  create_table "user_images", id: :serial, force: :cascade do |t|
    t.datetime "one_time_token_expires_at"
    t.string "one_time_token"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.integer "category"
    t.index ["user_id"], name: "index_user_images_on_user_id"
  end

  create_table "user_interests", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "interest_id"
    t.integer "level"
    t.integer "level_by_admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["interest_id"], name: "index_user_interests_on_interest_id"
    t.index ["user_id"], name: "index_user_interests_on_user_id"
  end

  create_table "user_languages", id: :serial, force: :cascade do |t|
    t.integer "language_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "proficiency"
    t.integer "proficiency_by_admin"
    t.index ["language_id", "user_id"], name: "index_user_languages_on_language_id_and_user_id", unique: true
    t.index ["language_id"], name: "index_user_languages_on_language_id"
    t.index ["user_id", "language_id"], name: "index_user_languages_on_user_id_and_language_id", unique: true
    t.index ["user_id"], name: "index_user_languages_on_user_id"
  end

  create_table "user_skills", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "skill_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "proficiency"
    t.integer "proficiency_by_admin"
    t.index ["skill_id", "user_id"], name: "index_user_skills_on_skill_id_and_user_id", unique: true
    t.index ["skill_id"], name: "index_user_skills_on_skill_id"
    t.index ["user_id", "skill_id"], name: "index_user_skills_on_user_id_and_skill_id", unique: true
    t.index ["user_id"], name: "index_user_skills_on_user_id"
  end

  create_table "user_tags", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_user_tags_on_tag_id"
    t.index ["user_id"], name: "index_user_tags_on_user_id"
  end

  create_table "user_translations", id: :serial, force: :cascade do |t|
    t.string "locale"
    t.text "description"
    t.text "job_experience"
    t.text "education"
    t.text "competence_text"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "language_id"
    t.index ["language_id"], name: "index_user_translations_on_language_id"
    t.index ["user_id"], name: "index_user_translations_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email"
    t.string "phone"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.integer "language_id"
    t.boolean "anonymized", default: false
    t.string "password_hash"
    t.string "password_salt"
    t.boolean "admin", default: false
    t.string "street"
    t.string "zip"
    t.float "zip_latitude"
    t.float "zip_longitude"
    t.string "first_name"
    t.string "last_name"
    t.string "ssn"
    t.integer "company_id"
    t.boolean "banned", default: false
    t.text "job_experience"
    t.text "education"
    t.string "one_time_token"
    t.datetime "one_time_token_expires_at"
    t.integer "ignored_notifications_mask"
    t.integer "frilans_finans_id"
    t.boolean "frilans_finans_payment_details", default: false
    t.text "competence_text"
    t.integer "current_status"
    t.integer "at_und"
    t.date "arrived_at"
    t.string "country_of_origin"
    t.boolean "managed", default: false
    t.string "account_clearing_number"
    t.string "account_number"
    t.boolean "verified", default: false
    t.string "skype_username"
    t.text "interview_comment"
    t.string "next_of_kin_name"
    t.string "next_of_kin_phone"
    t.date "arbetsformedlingen_registered_at"
    t.string "city"
    t.integer "interviewed_by_user_id"
    t.datetime "interviewed_at"
    t.boolean "just_arrived_staffing", default: false
    t.boolean "super_admin", default: false
    t.integer "gender"
    t.text "presentation_profile"
    t.text "presentation_personality"
    t.text "presentation_availability"
    t.integer "system_language_id"
    t.string "linkedin_url"
    t.string "facebook_url"
    t.boolean "has_welcome_app_account", default: false
    t.datetime "welcome_app_last_checked_at"
    t.boolean "public_profile", default: false
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["frilans_finans_id"], name: "index_users_on_frilans_finans_id", unique: true
    t.index ["language_id"], name: "index_users_on_language_id"
    t.index ["one_time_token"], name: "index_users_on_one_time_token", unique: true
    t.index ["system_language_id"], name: "index_users_on_system_language_id"
  end

  create_table "visits", id: :serial, force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.text "landing_page"
    t.integer "user_id"
    t.string "referring_domain"
    t.string "search_keyword"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.integer "screen_height"
    t.integer "screen_width"
    t.string "country"
    t.string "region"
    t.string "city"
    t.string "postal_code"
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_visits_on_user_id"
    t.index ["visit_token"], name: "index_visits_on_visit_token", unique: true
  end

  add_foreign_key "ahoy_events", "users", name: "ahoy_events_user_id_fk"
  add_foreign_key "ahoy_events", "visits", name: "ahoy_events_visit_id_fk"
  add_foreign_key "arbetsformedlingen_ad_logs", "arbetsformedlingen_ads"
  add_foreign_key "arbetsformedlingen_ads", "jobs"
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
  add_foreign_key "communication_template_translations", "communication_templates", name: "communication_template_translations_communication_template_id_f"
  add_foreign_key "communication_template_translations", "languages"
  add_foreign_key "communication_templates", "languages"
  add_foreign_key "companies", "users", column: "sales_user_id", name: "companies_sales_user_id_fk"
  add_foreign_key "company_images", "companies"
  add_foreign_key "company_industries", "companies"
  add_foreign_key "company_industries", "industries"
  add_foreign_key "company_translations", "companies"
  add_foreign_key "company_translations", "languages"
  add_foreign_key "digest_subscribers", "users"
  add_foreign_key "faq_translations", "faqs"
  add_foreign_key "faq_translations", "languages"
  add_foreign_key "faqs", "languages"
  add_foreign_key "feedbacks", "jobs"
  add_foreign_key "feedbacks", "users"
  add_foreign_key "filter_users", "filters"
  add_foreign_key "filter_users", "users"
  add_foreign_key "frilans_finans_invoices", "job_users"
  add_foreign_key "guide_section_article_translations", "guide_section_articles"
  add_foreign_key "guide_section_article_translations", "languages"
  add_foreign_key "guide_section_articles", "guide_sections"
  add_foreign_key "guide_section_articles", "languages"
  add_foreign_key "guide_section_translations", "guide_sections"
  add_foreign_key "guide_section_translations", "languages"
  add_foreign_key "guide_sections", "languages"
  add_foreign_key "industries", "languages"
  add_foreign_key "industry_translations", "industries"
  add_foreign_key "industry_translations", "languages"
  add_foreign_key "interest_filters", "filters"
  add_foreign_key "interest_filters", "interests"
  add_foreign_key "interest_translations", "interests"
  add_foreign_key "interest_translations", "languages"
  add_foreign_key "interests", "languages"
  add_foreign_key "invoices", "frilans_finans_invoices"
  add_foreign_key "invoices", "job_users"
  add_foreign_key "job_digest_addresses", "addresses"
  add_foreign_key "job_digest_addresses", "job_digests"
  add_foreign_key "job_digest_occupations", "job_digests"
  add_foreign_key "job_digest_occupations", "occupations"
  add_foreign_key "job_digests", "digest_subscribers"
  add_foreign_key "job_languages", "jobs"
  add_foreign_key "job_languages", "languages"
  add_foreign_key "job_occupations", "jobs"
  add_foreign_key "job_occupations", "occupations"
  add_foreign_key "job_requests", "companies"
  add_foreign_key "job_requests", "users", column: "delivery_user_id", name: "job_requests_delivery_user_id_fk"
  add_foreign_key "job_requests", "users", column: "sales_user_id", name: "job_requests_sales_user_id_fk"
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
  add_foreign_key "jobs", "orders"
  add_foreign_key "jobs", "users", column: "company_contact_user_id", name: "jobs_company_contact_user_id_fk"
  add_foreign_key "jobs", "users", column: "just_arrived_contact_user_id", name: "jobs_just_arrived_contact_user_id_fk"
  add_foreign_key "jobs", "users", column: "owner_user_id", name: "jobs_owner_user_id_fk"
  add_foreign_key "language_filters", "filters"
  add_foreign_key "language_filters", "languages", name: "language_filters_language_id_fk"
  add_foreign_key "message_translations", "languages"
  add_foreign_key "message_translations", "messages"
  add_foreign_key "messages", "chats"
  add_foreign_key "messages", "languages"
  add_foreign_key "messages", "users", column: "author_id", name: "messages_author_id_fk"
  add_foreign_key "occupation_translations", "languages"
  add_foreign_key "occupation_translations", "occupations"
  add_foreign_key "occupations", "languages"
  add_foreign_key "order_documents", "documents"
  add_foreign_key "order_documents", "orders"
  add_foreign_key "order_values", "order_values", column: "previous_order_value_id", name: "previous_order_value_id_fk"
  add_foreign_key "order_values", "orders"
  add_foreign_key "order_values", "users", column: "changed_by_user_id", name: "order_values_changed_by_user_id_fk"
  add_foreign_key "orders", "companies"
  add_foreign_key "orders", "job_requests"
  add_foreign_key "orders", "users", column: "delivery_user_id", name: "orders_delivery_user_id_fk"
  add_foreign_key "orders", "users", column: "sales_user_id", name: "orders_sales_user_id_fk"
  add_foreign_key "ratings", "jobs", name: "ratings_job_id_fk"
  add_foreign_key "ratings", "users", column: "from_user_id", name: "ratings_from_user_id_fk"
  add_foreign_key "ratings", "users", column: "to_user_id", name: "ratings_to_user_id_fk"
  add_foreign_key "skill_filters", "filters"
  add_foreign_key "skill_filters", "skills", name: "skill_filters_skill_id_fk"
  add_foreign_key "skill_translations", "languages"
  add_foreign_key "skill_translations", "skills"
  add_foreign_key "skills", "languages"
  add_foreign_key "terms_agreement_consents", "jobs"
  add_foreign_key "terms_agreement_consents", "terms_agreements"
  add_foreign_key "terms_agreement_consents", "users"
  add_foreign_key "terms_agreements", "frilans_finans_terms"
  add_foreign_key "tokens", "users"
  add_foreign_key "user_documents", "documents"
  add_foreign_key "user_documents", "users"
  add_foreign_key "user_images", "users"
  add_foreign_key "user_interests", "interests"
  add_foreign_key "user_interests", "users"
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
  add_foreign_key "users", "languages", column: "system_language_id", name: "users_system_language_id_fk"
  add_foreign_key "users", "users", column: "interviewed_by_user_id", name: "users_interviewed_by_user_id_fk"
  add_foreign_key "visits", "users", name: "visits_user_id_fk"
end
