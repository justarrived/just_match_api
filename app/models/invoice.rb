# frozen_string_literal: true
class Invoice < ApplicationRecord
  belongs_to :frilans_finans_invoice
  belongs_to :job_user

  has_one :job, through: :job_user
  has_one :user, through: :job_user

  validates :job_user, uniqueness: true, presence: true
  validates :frilans_finans_invoice, presence: true

  validate :validate_job_started
  validate :validate_job_user_accepted
  validate :validate_job_user_will_perform

  scope :needs_frilans_finans_activation, lambda {
    joins(:frilans_finans_invoice).
      where('frilans_finans_invoices.frilans_finans_id IS NOT NULL').
      where('frilans_finans_invoices.activated = false')
  }

  def name
    "Invoice ##{id}"
  end

  def validate_job_started
    job = job_user.try!(:job)
    return if job.nil? || job.started?

    message = I18n.t('errors.invoice.job_started')
    errors.add(:job, message)
  end

  def validate_job_user_accepted
    return if job_user.nil? || job_user.accepted

    message = I18n.t('errors.invoice.job_user_accepted')
    errors.add(:job_user, message)
  end

  def validate_job_user_will_perform
    return if job_user.nil? || job_user.will_perform

    message = I18n.t('errors.invoice.job_user_will_perform')
    errors.add(:job_user, message)
  end
end

# == Schema Information
#
# Table name: invoices
#
#  id                        :integer          not null, primary key
#  job_user_id               :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  frilans_finans_invoice_id :integer
#
# Indexes
#
#  index_invoices_on_frilans_finans_invoice_id  (frilans_finans_invoice_id)
#  index_invoices_on_job_user_id                (job_user_id)
#  index_invoices_on_job_user_id_uniq           (job_user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_bb8882afb5  (frilans_finans_invoice_id => frilans_finans_invoices.id)
#  fk_rails_c894e05ce5  (job_user_id => job_users.id)
#
