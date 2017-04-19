# frozen_string_literal: true

FactoryGirl.define do
  factory :order do
    job_request nil
    hourly_pay nil
    invoice_hourly_pay_rate '9.99'
    hours '9.99'
    lost false
  end
end

# == Schema Information
#
# Table name: orders
#
#  id                      :integer          not null, primary key
#  job_request_id          :integer
#  hourly_pay_id           :integer
#  invoice_hourly_pay_rate :decimal(, )
#  hours                   :decimal(, )
#  lost                    :boolean          default(FALSE)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_orders_on_hourly_pay_id   (hourly_pay_id)
#  index_orders_on_job_request_id  (job_request_id)
#
# Foreign Keys
#
#  fk_rails_7dd74d23d2  (job_request_id => job_requests.id)
#  fk_rails_e997d87207  (hourly_pay_id => hourly_pays.id)
#
