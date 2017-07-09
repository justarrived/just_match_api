# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :job_request

  has_many :jobs
  has_many :order_documents
  has_many :documents, through: :order_documents

  has_many :order_values

  scope :unfilled, (lambda {
    where(lost: false).
      joins('LEFT OUTER JOIN jobs ON jobs.order_id = orders.id').
      where('jobs.id IS NULL OR jobs.filled = false')
  })

  CATEGORIES = {
    freelance: 1,
    staffing: 2,
    direct_recruitment: 3
  }.freeze

  enum category: CATEGORIES

  # NOTE: This is necessary for nested activeadmin has_many form
  accepts_nested_attributes_for :order_documents, :documents, :order_values

  def self.total_revenue
    sum('invoice_hourly_pay_rate * orders.hours')
  end

  def display_name
    "##{id || 'unsaved'} #{name&.presence || job_request&.short_name || 'Order'}"
  end

  def filled_jobs
    jobs.filled
  end

  def current_order_value
    order_values.reorder(created_at: :desc).first
  end

  delegate :total_sold, to: :current_order_value
  delegate :total_filled, to: :current_order_value

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
#  name                           :string
#  category                       :integer
#
# Indexes
#
#  index_orders_on_job_request_id  (job_request_id)
#
# Foreign Keys
#
#  fk_rails_...  (job_request_id => job_requests.id)
#
