# frozen_string_literal: true

class Faq < ApplicationRecord
  belongs_to :language, optional: true

  include Translatable
  translates :question, :answer
end

# == Schema Information
#
# Table name: faqs
#
#  id          :integer          not null, primary key
#  answer      :text
#  question    :text
#  language_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_faqs_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#
