# frozen_string_literal: true

ActiveAdmin.register CompanyIndustry do
  menu parent: 'Jobs'

  actions :index, :show, :new, :create, :edit, :update

  permit_params do
    %i(company_id industry_id)
  end
end
