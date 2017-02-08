# frozen_string_literal: true
ActiveAdmin.register CompanyImage do
  menu parent: 'Misc', priority: 3

  index do
    selectable_column

    column :id
    column { |company_image| image_tag(company_image.image.url(:small)) }
    column :company
    column :created_at

    actions
  end

  form do |f|
    f.inputs do
      f.input :company
      f.input :image, required: true, as: :file
    end

    f.actions
  end

  permit_params do
    [:company_id, :image]
  end

  controller do
    def scoped_collection
      super.includes(:company)
    end
  end
end
