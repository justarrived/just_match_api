# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ArbetsformedlingenAd, type: :model do
  describe '#validate_job_data_for_arbetsformedlingen' do
    it 'adds error if the job data is *not* valid for Arbetsformedlingen' do
      category = FactoryGirl.build(:category, ssyk: nil)
      job = FactoryGirl.build(:job, category: category)
      ad = FactoryGirl.build(:arbetsformedlingen_ad, job: job, published: true)
      ad.validate
      expect(ad.errors.messages[:job]).to include('category ssyk must be filled')
    end

    it 'adds *no* error if the job data is valid for Arbetsformedlingen' do
      ad = FactoryGirl.build(:arbetsformedlingen_ad)
      ad.validate
      expect(ad.errors.messages[:job]).not_to include('ssyk must be filled')
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
#
# Indexes
#
#  index_arbetsformedlingen_ads_on_job_id  (job_id)
#
# Foreign Keys
#
#  fk_rails_b4811505f7  (job_id => jobs.id)
#
