# frozen_string_literal: true

class CompanyIndustry < ApplicationRecord
  belongs_to :company
  belongs_to :industry
end
