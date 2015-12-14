require 'rails_helper'

RSpec.describe ChatUser, regressor: true do
  # === Relations ===
  it { is_expected.to belong_to :chat }
  it { is_expected.to belong_to :user }

  # === Nested Attributes ===

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :chat_id }
  it { is_expected.to have_db_column :user_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ['chat_id'] }
  it { is_expected.to have_db_index ['user_id'] }

  # === Validations (Length) ===

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :chat }
  it { is_expected.to validate_presence_of :user }

  # === Validations (Numericality) ===

  # === Enums ===
end
