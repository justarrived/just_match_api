# frozen_string_literal: true
class FrilansFinansInvoice < ApplicationRecord
  belongs_to :job_user

  has_one :job, through: :job_user
  has_one :user, through: :job_user
  has_one :invoice

  validates :job_user, presence: true
  validates :frilans_finans_id, uniqueness: true, allow_nil: true

  scope :needs_frilans_finans_id, -> { where(frilans_finans_id: nil) }
  scope :activated, -> { where(activated: true) }
  scope :pre_report, -> { where(activated: false) }

  validate :validates_job_user_will_perform

  def name
    "Frilans Finans Invoice ##{id}"
  end

  def validates_job_user_will_perform
    return if job_user.try!(:will_perform)

    errors.add(:job_user_will_perform, I18n.t('errors.messages.accepted'))
  end
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
#  activated         :boolean          default(FALSE)
#
# Indexes
#
#  index_frilans_finans_invoices_on_job_user_id  (job_user_id)
#
# Foreign Keys
#
#  fk_rails_061906fba3  (job_user_id => job_users.id)
#
