# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Skill, regressor: true do
  # === Relations ===
  it { is_expected.to belong_to :language }

  it { is_expected.to have_many :job_skills }
  it { is_expected.to have_many :jobs }
  it { is_expected.to have_many :user_skills }
  it { is_expected.to have_many :users }

  # === Nested Attributes ===

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :language_id }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ['language_id'] }
  it { is_expected.to have_db_index ['name'] }

  # === Validations (Length) ===
  it { is_expected.to allow_value(Faker::Lorem.characters(3)).for :name }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(2)).for :name }

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :language }

  # === Validations (Numericality) ===

  # === Enums ===
end
