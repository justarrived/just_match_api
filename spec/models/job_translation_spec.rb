# frozen_string_literal: true
require 'rails_helper'

RSpec.describe JobTranslation, type: :model do
end

# == Schema Information
#
# Table name: job_translations
#
#  id                :integer          not null, primary key
#  locale            :string
#  short_description :string
#  name              :string
#  description       :text
#  job_id            :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_job_translations_on_job_id  (job_id)
#
# Foreign Keys
#
#  fk_rails_f6d3a9562e  (job_id => jobs.id)
#
