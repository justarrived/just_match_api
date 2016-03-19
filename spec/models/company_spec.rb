# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Company, type: :model do
end

# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  name       :string
#  cin        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_companies_on_cin  (cin) UNIQUE
#
