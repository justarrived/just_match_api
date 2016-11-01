# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UserTranslation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: user_translations
#
#  id              :integer          not null, primary key
#  locale          :string
#  description     :text
#  job_experience  :text
#  education       :text
#  competence_text :text
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_user_translations_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_4459d4650d  (user_id => users.id)
#
