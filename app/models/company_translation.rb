# frozen_string_literal: true

class CompanyTranslation < ApplicationRecord
  belongs_to :company

  include TranslationModel
end

# == Schema Information
#
# Table name: company_translations
#
#  id                :bigint(8)        not null, primary key
#  locale            :string
#  short_description :string
#  description       :text
#  language_id       :bigint(8)
#  company_id        :bigint(8)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_company_translations_on_company_id   (company_id)
#  index_company_translations_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#  fk_rails_...  (language_id => languages.id)
#
