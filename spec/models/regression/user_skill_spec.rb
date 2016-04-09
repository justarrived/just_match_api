# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UserSkill, regressor: true do
  # === Relations ===
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :skill }

  # === Nested Attributes ===

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :user_id }
  it { is_expected.to have_db_column :skill_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ['skill_id'] }
  it { is_expected.to have_db_index %w(skill_id user_id) }
  it { is_expected.to have_db_index ['user_id'] }
  it { is_expected.to have_db_index %w(user_id skill_id) }

  # === Validations (Length) ===

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :skill }
  it { is_expected.to validate_presence_of :user }

  # === Validations (Numericality) ===

  # === Enums ===
end
