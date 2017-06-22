# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompanyIndustry, type: :model do
end

# == Schema Information
#
# Table name: company_industries
#
#  id          :integer          not null, primary key
#  company_id  :integer
#  industry_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_company_industries_on_company_id   (company_id)
#  index_company_industries_on_industry_id  (industry_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#  fk_rails_...  (industry_id => industries.id)
#
