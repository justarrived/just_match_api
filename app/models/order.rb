# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :job_request

  has_many :jobs

  validates :hours, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :invoice_hourly_pay_rate, presence: true
  validates :hourly_pay_rate, presence: true, numericality: { greater_than_or_equal_to: 105 } # rubocop:disable Metrics/LineLength

  scope :unfilled, (lambda {
    where(lost: false).
      joins('LEFT OUTER JOIN jobs ON jobs.order_id = orders.id').
      where('jobs.id IS NULL OR jobs.filled = false')
  })

  def filled_jobs
    jobs.filled
  end

  def total_revenue
    invoice_hourly_pay_rate * hours
  end

  def total_filled_revenue
    filled_jobs.map { |job| job.hours * filled_invoice_hourly_pay_rate.to_f }.sum
  end
end

# == Schema Information
#
# Table name: orders
#
#  id                             :integer          not null, primary key
#  job_request_id                 :integer
#  invoice_hourly_pay_rate        :decimal(, )
#  hourly_pay_rate                :decimal(, )
#  hours                          :decimal(, )
#  lost                           :boolean          default(FALSE)
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  filled_hourly_pay_rate         :decimal(, )
#  filled_invoice_hourly_pay_rate :decimal(, )
#  filled_hours                   :decimal(, )
#
# Indexes
#
#  index_orders_on_job_request_id  (job_request_id)
#
# Foreign Keys
#
#  fk_rails_7dd74d23d2  (job_request_id => job_requests.id)
#
