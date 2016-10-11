# frozen_string_literal: true
ActiveAdmin.register Faq do
  permit_params do
    [:answer, :question, :language_id]
  end
end
