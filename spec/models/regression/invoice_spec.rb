# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Invoice, regressor: true do
  # === Relations ===
  it { is_expected.to belong_to :job_user }

  # === Nested Attributes ===

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :frilans_finans_id }
  it { is_expected.to have_db_column :job_user_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ['frilans_finans_id'] }
  it { is_expected.to have_db_index ['job_user_id'] }

  # === Validations (Length) ===

  # === Validations (Presence) ===

  # === Validations (Numericality) ===

  # === Enums ===
end
