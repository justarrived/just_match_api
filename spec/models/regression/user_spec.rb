require 'rails_helper'

RSpec.describe User, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :language }

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
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :email }
  it { is_expected.to have_db_column :phone }
  it { is_expected.to have_db_column :description }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :latitude }
  it { is_expected.to have_db_column :longitude }
  it { is_expected.to have_db_column :address }
  it { is_expected.to have_db_column :language_id }
  it { is_expected.to have_db_column :anonymized }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["language_id"] }

  # === Validations (Length) ===
  it { is_expected.to allow_value(Faker::Lorem.characters(3)).for :name }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(2)).for :name }
  it { is_expected.to allow_value(Faker::Lorem.characters(9)).for :phone }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(8)).for :phone }
  it { is_expected.to allow_value(Faker::Lorem.characters(10)).for :description }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(9)).for :description }
  it { is_expected.to allow_value(Faker::Lorem.characters(2)).for :address }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(1)).for :address }

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :language }

  # === Validations (Numericality) ===



  # === Enums ===


end
