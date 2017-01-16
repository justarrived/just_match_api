# frozen_string_literal: true
class JobRequest < ApplicationRecord
  belongs_to :company, optional: true

  scope :finished, -> { where(finished: true) }
  scope :pending, -> { where(finished: false) }

  after_create :send_created_notice

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
#  company_id            :integer
#  company_address       :string
#
# Indexes
#
#  index_job_requests_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_53030c1fe0  (company_id => companies.id)
#
