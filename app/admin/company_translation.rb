# frozen_string_literal: true

ActiveAdmin.register CompanyTranslation do
  permit_params do
    %i(
      locale
      short_description
      description
      language_id
      company_id
    )
  end
end
