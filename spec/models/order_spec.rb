# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#validate_job_request_company_match' do
    it 'adds no errors when job request is nil' do
      order = Order.new
      order.validate_job_request_company_match

      expect(order.errors.full_messages.any?).to eq(false)
    end

    it 'adds no errors when job request company is nil' do
      order = Order.new(job_request: JobRequest.new)
      order.validate_job_request_company_match

      expect(order.errors.full_messages.any?).to eq(false)
    end

    it 'adds no errors when job request company matches order company' do
      company = Company.new
      order = Order.new(job_request: JobRequest.new(company: company))
      order.company = company
      order.validate_job_request_company_match

      expect(order.errors.full_messages.any?).to eq(false)
    end

    it 'adds errors when job request company does not matches order company' do
      company = Company.new
      order = Order.new(job_request: JobRequest.new(company: company))
      order.company = Company.new
      order.validate_job_request_company_match

      expect(order.errors.full_messages.any?).to eq(true)
    end
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
