# frozen_string_literal: true
require 'rails_helper'

RSpec.describe JobRequest, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
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
#
