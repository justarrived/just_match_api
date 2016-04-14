# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Faq, regressor: true do
  # === Relations ===
  it { is_expected.to belong_to :language }

  # === Nested Attributes ===

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :answer }
  it { is_expected.to have_db_column :question }
  it { is_expected.to have_db_column :language_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ['language_id'] }

  # === Validations (Length) ===

  # === Validations (Presence) ===

  # === Validations (Numericality) ===

  # === Enums ===
end
