# frozen_string_literal: true

class JobOccupation < ApplicationRecord
  belongs_to :job, optional: false
  belongs_to :occupation, optional: false

  validates :importance, presence: true

  IMPORTANCE_TYPES = {
    required: 1,
    important: 2,
    bonus: 3,
    irrelevant: 4
  }.freeze

  enum importance: IMPORTANCE_TYPES
end

# == Schema Information
#
# Table name: job_occupations
#
#  id                  :integer          not null, primary key
#  job_id              :integer
#  occupation_id       :integer
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
