# frozen_string_literal: true
class CompanySerializer < ActiveModel::Serializer
  attributes :id, :name
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
