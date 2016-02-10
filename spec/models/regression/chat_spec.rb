# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Chat, regressor: true do
  # === Relations ===

  it { is_expected.to have_many :chat_users }
  it { is_expected.to have_many :users }
  it { is_expected.to have_many :messages }

  # === Nested Attributes ===

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===

  # === Validations (Length) ===

  # === Validations (Presence) ===

  # === Validations (Numericality) ===

  # === Enums ===
end
