class UserLanguage < ActiveRecord::Base
  belongs_to :language
  belongs_to :user

  validates_presence_of :language, :user
end

# == Schema Information
#
# Table name: user_languages
#
#  id          :integer          not null, primary key
#  language_id :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_user_languages_on_language_id  (language_id)
#  index_user_languages_on_user_id      (user_id)
#
