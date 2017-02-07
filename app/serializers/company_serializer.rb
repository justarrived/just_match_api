# frozen_string_literal: true
class CompanySerializer < ApplicationSerializer
  ATTRIBUTES = [:name, :website, :cin, :street, :zip, :city, :phone, :email].freeze
  attributes ATTRIBUTES

  link(:self) { api_v1_company_url(object) }

  has_many :company_images
  has_many :users, if: -> { scope[:current_user]&.admin? }
end

# == Schema Information
#
# Table name: companies
#
#  id                :integer          not null, primary key
#  name              :string
#  cin               :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  frilans_finans_id :integer
#  website           :string
#  email             :string
#  street            :string
#  zip               :string
#  city              :string
#  phone             :string
#  billing_email     :string
#
# Indexes
#
#  index_companies_on_cin                (cin) UNIQUE
#  index_companies_on_frilans_finans_id  (frilans_finans_id) UNIQUE
#
