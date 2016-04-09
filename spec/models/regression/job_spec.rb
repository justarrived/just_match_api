# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Job, regressor: true do
  # === Relations ===
  it { is_expected.to belong_to :language }
  it { is_expected.to belong_to :category }
  it { is_expected.to belong_to :hourly_pay }
  it { is_expected.to belong_to :owner }
  it { is_expected.to have_one :company }
  it { is_expected.to have_many :job_skills }
  it { is_expected.to have_many :skills }
  it { is_expected.to have_many :job_users }
  it { is_expected.to have_many :users }
  it { is_expected.to have_many :comments }

  # === Nested Attributes ===

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :description }
  it { is_expected.to have_db_column :job_date }
  it { is_expected.to have_db_column :hours }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :owner_user_id }
  it { is_expected.to have_db_column :latitude }
  it { is_expected.to have_db_column :longitude }
  it { is_expected.to have_db_column :language_id }
  it { is_expected.to have_db_column :street }
  it { is_expected.to have_db_column :zip }
  it { is_expected.to have_db_column :zip_latitude }
  it { is_expected.to have_db_column :zip_longitude }
  it { is_expected.to have_db_column :hidden }
  it { is_expected.to have_db_column :category_id }
  it { is_expected.to have_db_column :hourly_pay_id }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ['category_id'] }
  it { is_expected.to have_db_index ['hourly_pay_id'] }
  it { is_expected.to have_db_index ['language_id'] }

  # === Validations (Length) ===
  it { is_expected.to allow_value(Faker::Lorem.characters(2)).for :name }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(1)).for :name }
  it { is_expected.to allow_value(Faker::Lorem.characters(10)).for :description }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(9)).for :description }
  it { is_expected.to allow_value(Faker::Lorem.characters(5)).for :street }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(4)).for :street }
  it { is_expected.to allow_value(Faker::Lorem.characters(5)).for :zip }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(4)).for :zip }

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :language }
  it { is_expected.to validate_presence_of :hourly_pay }
  it { is_expected.to validate_presence_of :category }
  it { is_expected.to validate_presence_of :job_date }
  it { is_expected.to validate_presence_of :owner }

  # === Validations (Numericality) ===
  it { is_expected.to validate_numericality_of(:hours).is_greater_than_or_equal_to(1) }
  it { is_expected.not_to validate_numericality_of(:hours).is_greater_than_or_equal_to(0) }

  # === Enums ===
end
