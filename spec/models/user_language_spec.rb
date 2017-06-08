# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserLanguage, type: :model do
end

# == Schema Information
#
# Table name: user_languages
#
#  id                   :integer          not null, primary key
#  language_id          :integer
#  user_id              :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  proficiency          :integer
#  proficiency_by_admin :integer
#
# Indexes
#
#  index_user_languages_on_language_id              (language_id)
#  index_user_languages_on_language_id_and_user_id  (language_id,user_id) UNIQUE
#  index_user_languages_on_user_id                  (user_id)
#  index_user_languages_on_user_id_and_language_id  (user_id,language_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#  fk_rails_...  (user_id => users.id)
#
