# frozen_string_literal: true

FactoryBot.define do
  factory :job_user do
    association :user
    association :job
    association :language

    accepted false
    will_perform false

    factory :job_user_passed_job do
      association :job, factory: :passed_job
      accepted true
      will_perform true

      after(:create) do |job_user, _evaluator|
        # Unless explicitly given a Frilans Finans Invoice add a default, valid, one
        if job_user.frilans_finans_invoice.nil?
          ff_invoice = FrilansFinansInvoice.find_or_create_by!(job_user_id: job_user.id)
          job_user.frilans_finans_invoice = ff_invoice
        end
      end
    end

    factory :job_user_concluded do
      association :job, factory: :passed_job
      accepted true
      will_perform true
      after(:create) do |job_user, _evaluator|
        # Unless explicitly given a Invoice add a default, valid, one
        if job_user.invoice.nil?
          ff_invoice = FrilansFinansInvoice.find_or_create_by!(job_user_id: job_user.id)
          invoice = Invoice.find_or_create_by!(
            job_user_id: job_user.id,
            frilans_finans_invoice: ff_invoice
          )
          job_user.invoice = invoice
        end
      end
    end

    factory :job_user_accepted do
      accepted true
    end

    factory :job_user_will_perform do
      accepted true
      will_perform true
    end

    factory :job_user_for_docs do
      id 1
      created_at Time.new(2016, 2, 10, 1, 1, 1).utc
      updated_at Time.new(2016, 2, 12, 1, 1, 1).utc
    end
  end
end

# == Schema Information
#
# Table name: job_users
#
#  id                    :integer          not null, primary key
#  user_id               :integer
#  job_id                :integer
#  accepted              :boolean          default(FALSE)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  will_perform          :boolean          default(FALSE)
#  accepted_at           :datetime
#  performed             :boolean          default(FALSE)
#  apply_message         :text
#  language_id           :integer
#  application_withdrawn :boolean          default(FALSE)
#  shortlisted           :boolean          default(FALSE)
#  rejected              :boolean          default(FALSE)
#  http_referrer         :string(2083)
#  utm_source            :string
#  utm_medium            :string
#  utm_campaign          :string
#  utm_term              :string
#  utm_content           :string
#
# Indexes
#
#  index_job_users_on_job_id              (job_id)
#  index_job_users_on_job_id_and_user_id  (job_id,user_id) UNIQUE
#  index_job_users_on_language_id         (language_id)
#  index_job_users_on_user_id             (user_id)
#  index_job_users_on_user_id_and_job_id  (user_id,job_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (job_id => jobs.id)
#  fk_rails_...  (language_id => languages.id)
#  fk_rails_...  (user_id => users.id)
#
