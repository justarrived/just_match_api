# frozen_string_literal: true

class FrilansFinansInvoice < ApplicationRecord
  FF_PAID_STATUS = 2

  belongs_to :job_user

  has_one :job, through: :job_user
  has_one :user, through: :job_user
  has_one :invoice

  validates :job_user, presence: true
  validates :frilans_finans_id, uniqueness: true, allow_nil: true

  scope :needs_frilans_finans_id, (lambda {
    joins(:job).
      where('jobs.staffing_job = ?', false).
      where('jobs.direct_recruitment_job = ?', false).
      where(frilans_finans_id: nil)
  })
  scope :has_frilans_finans_id, (-> { where.not(frilans_finans_id: nil) })
  scope :activated, (-> { where(activated: true) })
  scope :pre_report, (-> { where(activated: false) })
  scope :not_paid, (-> { where('ff_status IS NULL OR ff_status != ?', FF_PAID_STATUS) })
  scope :paid, (-> { where(ff_status: FF_PAID_STATUS) })
  scope :uncancelled_jobs, (-> { joins(:job).where('jobs.cancelled = ?', false) })

  scope :job_ended, (lambda { |start:, finish:|
    joins(:job).
      where('jobs.job_end_date > ? AND jobs.job_end_date < ?', start, finish)
  })

  validate :validates_job_user_will_perform, on: :create
  validate :validate_job_frilans_finans_job

  FFInvoiceStatuses = FrilansFinansApi::Statuses::Invoice

  def self.sent_invoices(start:, finish:)
    activated.job_ended(start: start, finish: finish)
  end

  def self.invoice_amount(start:, finish:)
    sent_invoices(start: start, finish: finish).
      sum(:ff_amount)
  end

  def name
    display_name
  end

  def display_name
    name = " (#{ff_status_name})" if ff_status_name
    "##{id} #{human_model_name}#{name}"
  end

  def ff_status_name(with_id: false)
    FFInvoiceStatuses.status(ff_status, with_id: with_id)
  end

  def ff_payment_status_name(with_id: false)
    FFInvoiceStatuses.payment_status(ff_payment_status, with_id: with_id)
  end

  def ff_approval_status_name(with_id: false)
    FFInvoiceStatuses.approval_status(ff_approval_status, with_id: with_id)
  end

  def validate_job_frilans_finans_job
    return if job&.frilans_finans_job?

    message = I18n.t('errors.frilans_finans_invoice.job_is_frilans_finans_job')
    errors.add(:job, message)
  end

  def validates_job_user_will_perform
    return if job_user&.will_perform

    errors.add(:job_user_will_perform, I18n.t('errors.messages.accepted'))
  end
end

# == Schema Information
#
# Table name: frilans_finans_invoices
#
#  id                 :integer          not null, primary key
#  frilans_finans_id  :integer
#  job_user_id        :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  activated          :boolean          default(FALSE)
#  ff_pre_report      :boolean          default(TRUE)
#  ff_amount          :float
#  ff_gross_salary    :float
#  ff_net_salary      :float
#  ff_payment_status  :integer
#  ff_approval_status :integer
#  ff_status          :integer
#  ff_sent_at         :datetime
#  express_payment    :boolean          default(FALSE)
#  ff_last_synced_at  :datetime
#  ff_invoice_number  :integer
#
# Indexes
#
#  index_frilans_finans_invoices_on_job_user_id  (job_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (job_user_id => job_users.id)
#
