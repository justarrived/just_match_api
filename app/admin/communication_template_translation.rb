# frozen_string_literal: true

ActiveAdmin.register CommunicationTemplateTranslation do
  menu parent: 'Misc'

  permit_params do
    %i(language_id communication_template_id subject body locale)
  end
end
