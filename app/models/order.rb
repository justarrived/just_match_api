# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :job_request, optional: true
  belongs_to :company
  belongs_to :delivery_user, optional: true, class_name: 'User', foreign_key: 'delivery_user_id' # rubocop:disable Metrics/LineLength
  belongs_to :sales_user, optional: true, class_name: 'User', foreign_key: 'sales_user_id'

  has_many :jobs
  has_many :order_documents
  has_many :documents, through: :order_documents

  has_many :order_values

  validates :company, presence: true
  validates :delivery_user, presence: true
  validates :sales_user, presence: true

  validate :validate_sales_and_delivery_user_not_equal

  scope :lost, (-> { where(lost: true) })
  scope :unlost, (-> { where(lost: false) })
  scope :unfilled, (lambda {
    joins('LEFT OUTER JOIN jobs ON orders.id = jobs.order_id').
      where('jobs.id IS NULL OR (jobs.filled = false AND jobs.cancelled = false)').
      distinct
  })
  scope :filled, (-> { where.not(id: unfilled.map(&:id)) })
  scope :unfilled_and_unlost, (-> { unlost.unfilled })
  scope :filled_and_unlost, (-> { unlost.filled })

  CATEGORIES = {
    freelance: 1,
    staffing: 2,
    direct_recruitment: 3
  }.freeze

  enum category: CATEGORIES

  # NOTE: This is necessary for nested activeadmin has_many form
  accepts_nested_attributes_for :order_documents, :documents, :order_values

  validate :validate_job_request_company_match

  def self.total_revenue_to_fill
    includes(:order_values).
      unfilled_and_unlost.
      map do |order|

      order_value = order.current_order_value

      if order_value
        order_value.sold_total_value - order_value.filled_total_value
      else
        0.0
      end
    end.sum
  end

  def validate_sales_and_delivery_user_not_equal
    return unless sales_user
    return unless delivery_user
    return unless sales_user == delivery_user

    error_message = I18n.t('errors.order.sales_and_delivery_user_equal')
    errors.add(:delivery_user, error_message)
    errors.add(:sales_user, error_message)
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

  def validate_job_request_company_match
    return unless job_request
    return unless job_request.company
    return if job_request.company == company

    errors.add(:company, I18n.t('errors.order.job_request_company_match'))
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
#  company_id                     :integer
#  sales_user_id                  :integer
#  delivery_user_id               :integer
#
# Indexes
#
#  index_orders_on_company_id        (company_id)
#  index_orders_on_delivery_user_id  (delivery_user_id)
#  index_orders_on_job_request_id    (job_request_id)
#  index_orders_on_sales_user_id     (sales_user_id)
#
# Foreign Keys
#
#  fk_rails_...                (company_id => companies.id)
#  fk_rails_...                (job_request_id => job_requests.id)
#  orders_delivery_user_id_fk  (delivery_user_id => users.id)
#  orders_sales_user_id_fk     (sales_user_id => users.id)
#
