# frozen_string_literal: true
ActiveAdmin.register Faq do
  menu parent: 'Misc'

  include AdminHelpers::MachineTranslation::Actions

  after_save do |faq|
    translation_params = {
      question: permitted_params.dig(:faq, :question),
      answer: permitted_params.dig(:faq, :answer)
    }
    faq.set_translation(translation_params)
  end

  permit_params do
    [:question, :answer, :language_id]
  end
end
