# frozen_string_literal: true
ActiveAdmin.register CompanyImage do
  menu parent: 'Misc'

  index do
    selectable_column

    column :id
    column { |company_image| image_tag(company_image.image.url(:small)) }
    column :company
    column :created_at

    actions
  end

  controller do
    def scoped_collection
      super.includes(:company)
    end
  end
end
