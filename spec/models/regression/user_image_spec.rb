# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UserImage, regressor: true do
  # === Relations ===
  it { is_expected.to belong_to :user }

  # === Nested Attributes ===

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :one_time_token_expires_at }
  it { is_expected.to have_db_column :one_time_token }
  it { is_expected.to have_db_column :user_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :image_file_name }
  it { is_expected.to have_db_column :image_content_type }
  it { is_expected.to have_db_column :image_file_size }
  it { is_expected.to have_db_column :image_updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ['user_id'] }

  # === Validations (Length) ===

  # === Validations (Presence) ===

  # === Validations (Numericality) ===

  # === Enums ===
end
