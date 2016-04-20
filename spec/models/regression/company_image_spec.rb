# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CompanyImage, regressor: true do
  # === Relations ===
  it { is_expected.to belong_to :company }

  # === Nested Attributes ===

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :one_time_token }
  it { is_expected.to have_db_column :company_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ['company_id'] }

  # === Validations (Length) ===

  # === Validations (Presence) ===

  # === Validations (Numericality) ===

  # === Enums ===
end
