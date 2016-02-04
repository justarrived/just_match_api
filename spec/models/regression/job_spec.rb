require 'rails_helper'

RSpec.describe Job, regressor: true do
  # === Relations ===
  it { is_expected.to belong_to :language }
  it { is_expected.to belong_to :owner }

  it { is_expected.to have_many :job_skills }
  it { is_expected.to have_many :skills }
  it { is_expected.to have_many :job_users }
  it { is_expected.to have_many :users }
  it { is_expected.to have_many :comments }

  # === Nested Attributes ===

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :max_rate }
  it { is_expected.to have_db_column :description }
  it { is_expected.to have_db_column :job_date }
  it { is_expected.to have_db_column :performed_accept }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :owner_user_id }
  it { is_expected.to have_db_column :latitude }
  it { is_expected.to have_db_column :longitude }
  it { is_expected.to have_db_column :street }
  it { is_expected.to have_db_column :zip }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :hours }
  it { is_expected.to have_db_column :language_id }

  # === Database (Indexes) ===
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
  it { is_expected.to validate_presence_of :owner }
  it { is_expected.to validate_presence_of :job_date }

  # === Validations (Numericality) ===
  it { is_expected.to validate_numericality_of(:max_rate).only_integer }

  # === Enums ===
end
