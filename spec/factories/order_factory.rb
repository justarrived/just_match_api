# frozen_string_literal: true

FactoryGirl.define do
  factory :order do
    association :job_request

    hourly_pay_rate 119.98
    invoice_hourly_pay_rate 1119.99
    hours 119.99

    filled_hourly_pay_rate 181.98
    filled_invoice_hourly_pay_rate 218.99
    filled_hours 99.99

    lost false
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
#
# Indexes
#
#  index_orders_on_company_id      (company_id)
#  index_orders_on_job_request_id  (job_request_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#  fk_rails_...  (job_request_id => job_requests.id)
#
