# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ArbetsformedlingenAd, type: :model do
  describe '#validate_job_data_for_arbetsformedlingen' do
    it 'adds error if the job data is *not* valid for Arbetsformedlingen' do
      job = FactoryBot.build(:job, number_to_fill: nil)
      ad = FactoryBot.build(:arbetsformedlingen_ad, job: job, published: true)

      allow(AppConfig).to receive(:default_staffing_company_id).and_return(job.company.id)

      ad.validate
      expect(ad.errors.messages[:job]).to include('number to fill must be filled')
    end

    it 'adds *no* error if the job data is valid for Arbetsformedlingen' do
      ad = FactoryBot.build(:arbetsformedlingen_ad)
      ad.validate
      expect(ad.errors).to be_empty
    end
  end
end

# == Schema Information
#
# Table name: arbetsformedlingen_ads
#
#  id         :integer          not null, primary key
#  job_id     :integer
#  published  :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  occupation :string
#
# Indexes
#
#  index_arbetsformedlingen_ads_on_job_id  (job_id)
#
# Foreign Keys
#
#  fk_rails_...  (job_id => jobs.id)
#
