# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Message, regressor: true do
  # === Relations ===
  it { is_expected.to belong_to :chat }
  it { is_expected.to belong_to :author }
  it { is_expected.to belong_to :language }

  # === Nested Attributes ===

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :chat_id }
  it { is_expected.to have_db_column :author_id }
  it { is_expected.to have_db_column :integer }
  it { is_expected.to have_db_column :language_id }
  it { is_expected.to have_db_column :body }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ['chat_id'] }
  it { is_expected.to have_db_index ['language_id'] }

  # === Validations (Length) ===

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :body }
  it { is_expected.to validate_presence_of :chat }
  it { is_expected.to validate_presence_of :author }

  # === Validations (Numericality) ===

  # === Enums ===
end
