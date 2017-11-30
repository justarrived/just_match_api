# frozen_string_literal: true

ActiveAdmin.register GuideImage do
  menu parent: 'Guide', priority: 5

  index do
    selectable_column

    column :id
    column { |guide_image| image_tag(guide_image.image.url(:small)) }
    column :created_at

    actions
  end

  show do
    large_url = guide_image.image.url(:large)

    attributes_table do
      row :id
      row :guide_image { image_tag(large_url) }
      row :url { large_url }
      row :created_at
      row :updated_at
      row :image_file_name
      row :image_content_type
      row :image_file_size do |guide_image|
        number_to_human_size(guide_image.image_file_size)
      end
      row :image_updated_at
    end

    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :title, hint: I18n.t('admin.guide_image.form.title.hint')
      f.input(
        :image,
        required: true,
        as: :file,
        hint: I18n.t(
          'admin.guide_image.form.image.hint',
          formats: GuideImage.format_names.to_sentence
        )
      )
    end

    f.actions
  end

  permit_params do
    %i[title image]
  end
end
