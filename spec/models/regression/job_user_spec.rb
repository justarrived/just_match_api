# frozen_string_literal: true
require 'rails_helper'

RSpec.describe JobUser, regressor: true do
  # === Relations ===
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :job }

  # === Nested Attributes ===

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :user_id }
  it { is_expected.to have_db_column :job_id }
  it { is_expected.to have_db_column :accepted }
  it { is_expected.to have_db_column :rate }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :performed }
  it { is_expected.to have_db_column :performed_accepted }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ['job_id'] }
  it { is_expected.to have_db_index ['user_id'] }

  # === Validations (Length) ===

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :user }
  it { is_expected.to validate_presence_of :job }

  # === Validations (Numericality) ===

  # === Enums ===
end
