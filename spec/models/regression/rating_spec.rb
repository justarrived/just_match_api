require 'rails_helper'

RSpec.describe Rating, regressor: true do

  # === Relations ===
  it { is_expected.to belong_to :from_user }
  it { is_expected.to belong_to :to_user }
  it { is_expected.to belong_to :job }
  it { is_expected.to have_one :comment }
  

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :from_user_id }
  it { is_expected.to have_db_column :to_user_id }
  it { is_expected.to have_db_column :job_id }
  it { is_expected.to have_db_column :score }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["job_id", "from_user_id"] }
  it { is_expected.to have_db_index ["job_id", "to_user_id"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :score }
  it { is_expected.to validate_presence_of :job }
  it { is_expected.to validate_presence_of :from_user }
  it { is_expected.to validate_presence_of :to_user }

  # === Validations (Numericality) ===
  it { is_expected.to validate_numericality_of(:score).only_integer }

  
  # === Enums ===
  
  
end