# frozen_string_literal: true
class Language < ActiveRecord::Base
  has_many :user_languages
  has_many :users, through: :user_languages

  has_many :jobs

  validates :lang_code, uniqueness: true, presence: true
end

# == Schema Information
#
# Table name: languages
#
#  id         :integer          not null, primary key
#  lang_code  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_languages_on_lang_code  (lang_code) UNIQUE
#
