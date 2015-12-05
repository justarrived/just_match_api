class Skill < ActiveRecord::Base
  has_many :job_skills
  has_many :jobs, through: :skill

  has_many :user_skills
  has_many :users, through: :user_skills

  validates :name, length: { minimum: 3 }, allow_blank: false
  validates_uniqueness_of :name
end

# == Schema Information
#
# Table name: skills
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
