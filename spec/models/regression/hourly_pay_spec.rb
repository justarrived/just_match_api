# frozen_string_literal: true
require 'rails_helper'

RSpec.describe HourlyPay, regressor: true do
  # === Relations ===

  it { is_expected.to have_many :jobs }

  # === Nested Attributes ===

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :active }
  it { is_expected.to have_db_column :gross_salary }
  it { is_expected.to have_db_column :currency }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===

  # === Validations (Length) ===

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :gross_salary }

  # === Validations (Numericality) ===
  it { is_expected.to validate_numericality_of(:gross_salary).only_integer }

  # === Enums ===
end
