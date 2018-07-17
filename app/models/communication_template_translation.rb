# frozen_string_literal: true

class CommunicationTemplateTranslation < ApplicationRecord
  belongs_to :communication_template

  include TranslationModel
end

# rubocop:disable Metrics/LineLength
#
# == Schema Information
#
# Table name: communication_template_translations
#
#  id                        :integer          not null, primary key
#  subject                   :string
#  body                      :text
#  language_id               :integer
#  locale                    :string
#  communication_template_id :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
# Indexes
#
#  index_comm_template_translations_on_comm_template_id      (communication_template_id)
#  index_communication_template_translations_on_language_id  (language_id)
#
# Foreign Keys
#
#  communication_template_translations_communication_template_id_f  (communication_template_id => communication_templates.id)
#  fk_rails_...                                                     (language_id => languages.id)
#
# rubocop:enable Metrics/LineLength
