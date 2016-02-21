# frozen_string_literal: true
require 'rails_helper'

RSpec.describe JobSkill, regressor: true do
  # === Relations ===
  it { is_expected.to belong_to :job }
  it { is_expected.to belong_to :skill }

  # === Nested Attributes ===

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :job_id }
  it { is_expected.to have_db_column :skill_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ['job_id'] }
  it { is_expected.to have_db_index ['skill_id'] }

  # === Validations (Length) ===

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :skill }
  it { is_expected.to validate_presence_of :job }

  # === Validations (Numericality) ===

  # === Enums ===
end
