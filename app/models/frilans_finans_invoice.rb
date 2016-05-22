# frozen_string_literal: true
class FrilansFinansInvoice < ActiveRecord::Base
  belongs_to :job_user

  has_one :job, through: :job_user
  has_one :user, through: :job_user
  has_one :invoice

  validates :frilans_finans_id, uniqueness: true, allow_nil: true

  scope :needs_frilans_finans_id, -> { where(frilans_finans_id: nil) }

  # TODO: Validate JobUser#will_perform == true
end

# == Schema Information
#
# Table name: frilans_finans_invoices
#
#  id                :integer          not null, primary key
#  frilans_finans_id :integer
#  job_user_id       :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_frilans_finans_invoices_on_job_user_id  (job_user_id)
#
# Foreign Keys
#
#  fk_rails_061906fba3  (job_user_id => job_users.id)
#
