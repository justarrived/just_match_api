# frozen_string_literal: true

class CompanySerializer < ApplicationSerializer
  ATTRIBUTES = %i(website cin street zip city phone email).freeze
  attributes ATTRIBUTES

  link(:self) { api_v1_company_url(object) }

  attribute(:name) { object.display_name }

  attribute :short_description do
    object.original_short_description
  end

  attribute :description do
    object.original_description
  end

  attribute :description_html do
    to_html(object.original_description)
  end

  attribute :translated_text do
    {
      short_description: object.translated_short_description,
      description: object.translated_description,
      description_html: to_html(object.translated_description),
      language_id: object.translated_language_id
    }
  end

  has_many :company_images
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
#  municipality      :string
#  staffing_agency   :boolean          default(FALSE)
#  display_name      :string
#  sales_user_id     :integer
#
# Indexes
#
#  index_companies_on_cin                (cin) UNIQUE
#  index_companies_on_frilans_finans_id  (frilans_finans_id) UNIQUE
#
# Foreign Keys
#
#  companies_sales_user_id_fk  (sales_user_id => users.id)
#
