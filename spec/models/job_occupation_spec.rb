# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobOccupation, type: :model do
end

# == Schema Information
#
# Table name: job_occupations
#
#  id                  :bigint(8)        not null, primary key
#  job_id              :bigint(8)
#  occupation_id       :bigint(8)
#  years_of_experience :integer
#  importance          :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_job_occupations_on_job_id         (job_id)
#  index_job_occupations_on_occupation_id  (occupation_id)
#
# Foreign Keys
#
#  fk_rails_...  (job_id => jobs.id)
#  fk_rails_...  (occupation_id => occupations.id)
#
