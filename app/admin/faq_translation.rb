# frozen_string_literal: true

ActiveAdmin.register FaqTranslation do
  menu parent: 'Misc'

  permit_params do
    %i(question answer locale language_id faq_id)
  end
end
