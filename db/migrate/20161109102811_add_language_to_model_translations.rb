# frozen_string_literal: true
class AddLanguageToModelTranslations < ActiveRecord::Migration[5.0]
  def change
    add_reference :comment_translations,  :language, foreign_key: true
    add_reference :message_translations,  :language, foreign_key: true
    add_reference :job_translations,      :language, foreign_key: true
    add_reference :job_user_translations, :language, foreign_key: true
    add_reference :user_translations,     :language, foreign_key: true
  end
end
