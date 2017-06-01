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

  show do
    attributes_table do
      row :id
      row :company
      row :company_image do |company_image|
        image_tag(company_image.image.url(:large))
      end
      row :created_at
      row :updated_at
      row :image_file_name
      row :image_content_type
      row :image_file_size do |company_image|
        number_to_human_size(company_image.image_file_size)
      end
      row :image_updated_at
    end

    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :company
      f.input :image, required: true, as: :file
    end

    f.actions
  end

  permit_params do
    %i(company_id image)
  end

  controller do
    def scoped_collection
      super.includes(:company)
    end
  end
end
