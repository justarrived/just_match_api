# frozen_string_literal: true
class JobRequest < ApplicationRecord
  belongs_to :company, optional: true
  belongs_to :delivery_user, optional: true, class_name: 'User', foreign_key: 'delivery_user_id' # rubocop:disable Metrics/LineLength
  belongs_to :sales_user, optional: true, class_name: 'User', foreign_key: 'sales_user_id'

  has_one :order

  scope :finished, -> { where(finished: true) }
  scope :pending, -> { where(finished: false) }
  scope :last_30_days, -> { where('created_at > ?', 30.days.ago) }

  after_create :send_created_notice

  def current_status_name
    return 'Cancelled' if cancelled
    return 'Finished' if finished
    return 'Signed by customer' if signed_by_customer
    return 'Draft sent' if draft_sent
    'New'
  end

  def send_created_notice
    NewJobRequestNotifier.call(job_request: self)
  end
end

# == Schema Information
#
# Table name: job_requests
#
#  id                    :integer          not null, primary key
#  company_name          :string
#  contact_string        :string
#  assignment            :string
#  job_scope             :string
#  job_specification     :string
#  language_requirements :string
#  job_at_date           :string
#  responsible           :string
#  suitable_candidates   :string
#  comment               :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  short_name            :string
#  finished              :boolean          default(FALSE)
#  cancelled             :boolean          default(FALSE)
#  draft_sent            :boolean          default(FALSE)
#  signed_by_customer    :boolean          default(FALSE)
#  requirements          :string
#  hourly_pay            :string
#  company_org_no        :string
#  company_email         :string
#  company_phone         :string
#  company_address       :string
#  company_id            :integer
#  delivery_user_id      :integer
#  sales_user_id         :integer
#
# Indexes
#
#  index_job_requests_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_53030c1fe0               (company_id => companies.id)
#  job_requests_delivery_user_id_fk  (delivery_user_id => users.id)
#  job_requests_sales_user_id_fk     (sales_user_id => users.id)
#
