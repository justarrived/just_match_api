class Language < ActiveRecord::Base
  has_many :user_languages
  has_many :users, through: :user_languages

  has_many :jobs

  validates :lang_code, presence: true
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
