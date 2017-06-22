# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobIndustry, type: :model do
end

# == Schema Information
#
# Table name: job_industries
#
#  id                  :integer          not null, primary key
#  job_id              :integer
#  industry_id         :integer
#  years_of_experience :integer
#  importance          :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_job_industries_on_industry_id  (industry_id)
#  index_job_industries_on_job_id       (job_id)
#
# Foreign Keys
#
#  fk_rails_...  (industry_id => industries.id)
#  fk_rails_...  (job_id => jobs.id)
#
