# frozen_string_literal: true
ActiveAdmin.register CommunicationTemplate do
  menu parent: 'Settings'

  include AdminHelpers::MachineTranslation::Actions

  form do |f|
    f.semantic_errors

    f.inputs 'Details' do
      f.input :language
      f.input :category, hint: 'You need a unique category name'
      f.input :subject, hint: 'Subject line of template you (can use variables here..)'
      f.input :body, hint: 'Body of template (you can use variables here..)'
    end

    content_tag(:p, 'WaTmAn')

    f.actions
  end

  after_save do |template|
    template.set_translation(
      name: permitted_params.dig(:communication_template, :name),
      subject: permitted_params.dig(:communication_template, :subject),
      body: permitted_params.dig(:communication_template, :body)
    )
  end

  permit_params do
    [:language_id, :category, :subject, :body]
  end

  controller do
    def scoped_collection
      super.with_translations
    end
  end
end
