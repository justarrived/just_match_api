# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Comment, regressor: true do
  # === Relations ===
  it { is_expected.to belong_to :commentable }
  it { is_expected.to belong_to :owner }
  it { is_expected.to belong_to :language }

  # === Nested Attributes ===

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :body }
  it { is_expected.to have_db_column :commentable_id }
  it { is_expected.to have_db_column :commentable_type }
  it { is_expected.to have_db_column :owner_user_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :language_id }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index %w(commentable_type commentable_id) }
  it { is_expected.to have_db_index ['language_id'] }

  # === Validations (Length) ===

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :owner_user_id }
  it { is_expected.to validate_presence_of :commentable_id }
  it { is_expected.to validate_presence_of :commentable_type }
  it { is_expected.to validate_presence_of :body }
  it { is_expected.to validate_presence_of :language }

  # === Validations (Numericality) ===

  # === Enums ===
end
