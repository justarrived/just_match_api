# frozen_string_literal: true

class CompanyIndustry < ApplicationRecord
  belongs_to :company
  belongs_to :industry
end

# == Schema Information
#
# Table name: company_industries
#
#  id          :bigint(8)        not null, primary key
#  company_id  :bigint(8)
#  industry_id :bigint(8)
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
