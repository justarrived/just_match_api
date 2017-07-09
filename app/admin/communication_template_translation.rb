# frozen_string_literal: true

ActiveAdmin.register CommunicationTemplateTranslation do
  menu parent: 'Misc'

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    communication_template = f.object.communication_template

    f.inputs 'Communication Template Translation' do
      f.input :communication_template
      f.input :language
      f.input :locale
      f.input :subject, hint: "[ORIGINAL] #{communication_template&.original_subject}"
      f.input :body, hint: "[ORIGINAL] #{communication_template&.original_body}"
    end

    f.actions
  end

  permit_params do
    %i(language_id communication_template_id subject body locale)
  end
end
