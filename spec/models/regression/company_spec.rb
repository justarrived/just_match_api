# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Company, regressor: true do
  # === Relations ===

  # === Nested Attributes ===

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :cin }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===

  # === Validations (Length) ===

  it { is_expected.to allow_value(Faker::Lorem.characters(2)).for :name }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(1)).for :name }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(9)).for :cin }
  it { is_expected.to allow_value(Faker::Lorem.characters(10)).for :cin }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(11)).for :cin }

  # === Validations (Presence) ===

  # === Validations (Numericality) ===

  # === Enums ===
end
