# frozen_string_literal: true
ActiveAdmin.register Faq do
  menu parent: 'Misc'

  include AdminHelpers::MachineTranslation::Actions

  SET_FAQ_TRANSLATION = lambda do |faq, permitted_params|
    return unless faq.persisted? && faq.valid?

    translation_params = {
      question: permitted_params.dig(:faq, :question),
      answer: permitted_params.dig(:faq, :answer)
    }
    faq.set_translation(translation_params)
  end

  after_create do |faq|
    SET_FAQ_TRANSLATION.call(faq, permitted_params)
  end

  after_save do |faq|
    SET_FAQ_TRANSLATION.call(faq, permitted_params)
  end

  permit_params do
    [:question, :answer, :language_id]
  end
end
