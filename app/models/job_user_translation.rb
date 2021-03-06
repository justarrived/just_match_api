# frozen_string_literal: true

class JobUserTranslation < ApplicationRecord
  belongs_to :job_user

  include TranslationModel
end

# == Schema Information
#
# Table name: job_user_translations
#
#  id            :integer          not null, primary key
#  locale        :string
#  apply_message :text
#  job_user_id   :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  language_id   :integer
#
# Indexes
#
#  index_job_user_translations_on_job_user_id  (job_user_id)
#  index_job_user_translations_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (job_user_id => job_users.id)
#  fk_rails_...  (language_id => languages.id)
#
