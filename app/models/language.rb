class Language < ActiveRecord::Base
  has_many :user_languages
  has_many :users, through: :user_languages

  has_many :jobs

  validates_presence_of :lang_code
end

# == Schema Information
#
# Table name: languages
#
#  id         :integer          not null, primary key
#  lang_code  :string
#  primary    :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
