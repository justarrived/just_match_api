# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User, regressor: true do
  # === Relations ===
  it { is_expected.to belong_to :language }
  it { is_expected.to belong_to :company }

  it { is_expected.to have_many :user_skills }
  it { is_expected.to have_many :skills }
  it { is_expected.to have_many :owned_jobs }
  it { is_expected.to have_many :job_users }
  it { is_expected.to have_many :jobs }
  it { is_expected.to have_many :user_languages }
  it { is_expected.to have_many :languages }
  it { is_expected.to have_many :written_comments }
  it { is_expected.to have_many :chat_users }
  it { is_expected.to have_many :chats }
  it { is_expected.to have_many :messages }

  # === Nested Attributes ===

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :email }
  it { is_expected.to have_db_column :phone }
  it { is_expected.to have_db_column :description }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :latitude }
  it { is_expected.to have_db_column :longitude }
  it { is_expected.to have_db_column :language_id }
  it { is_expected.to have_db_column :anonymized }
  it { is_expected.to have_db_column :password_hash }
  it { is_expected.to have_db_column :password_salt }
  it { is_expected.to have_db_column :admin }
  it { is_expected.to have_db_column :street }
  it { is_expected.to have_db_column :zip }
  it { is_expected.to have_db_column :zip_latitude }
  it { is_expected.to have_db_column :zip_longitude }
  it { is_expected.to have_db_column :first_name }
  it { is_expected.to have_db_column :last_name }
  it { is_expected.to have_db_column :ssn }
  it { is_expected.to have_db_column :company_id }
  it { is_expected.to have_db_column :banned }
  it { is_expected.to have_db_column :job_experience }
  it { is_expected.to have_db_column :education }
  it { is_expected.to have_db_column :one_time_token }
  it { is_expected.to have_db_column :one_time_token_expires_at }
  it { is_expected.to have_db_column :ignored_notifications_mask }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ['company_id'] }
  it { is_expected.to have_db_index ['email'] }
  it { is_expected.to have_db_index ['language_id'] }
  it { is_expected.to have_db_index ['one_time_token'] }

  # === Validations (Length) ===
  it { is_expected.to allow_value(Faker::Lorem.characters(2)).for :first_name }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(1)).for :first_name }
  it { is_expected.to allow_value(Faker::Lorem.characters(2)).for :last_name }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(1)).for :last_name }
  it { is_expected.to allow_value(Faker::Lorem.characters(10)).for :description }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(9)).for :description }
  it { is_expected.to allow_value(Faker::Lorem.characters(5)).for :street }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(4)).for :street }
  it { is_expected.to allow_value(Faker::Lorem.characters(5)).for :zip }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(4)).for :zip }
  it { is_expected.to allow_value(Faker::Lorem.characters(6)).for :password }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(5)).for :password }

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :language }
  it { is_expected.to validate_presence_of :email }

  # === Validations (Numericality) ===

  # === Enums ===
end
