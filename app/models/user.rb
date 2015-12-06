class User < ActiveRecord::Base
  include Geocodable
  include SkillMatcherQuery

  has_many :user_skills, inverse_of: :user
  has_many :skills, through: :user_skills

  has_many :job_users
  has_many :jobs, through: :job_users

  has_many :user_languages
  has_many :languages, through: :user_languages

  has_many :comments, as: :commentable
  has_many :written_comments, class_name: 'Comment', foreign_key: 'owner_user_id'

  validates_presence_of :email
  # TODO: Validates format of email
  # validates :email, email: true, allow_blank: false
  validates :name, length: { minimum: 3 }, allow_blank: false
  validates :phone, length: { minimum: 9 }, allow_blank: false
  validates :description, length: { minimum: 10 }, allow_blank: false
  validates :address, length: { minimum: 2 }, allow_blank: false

  def self.matches_job(job, distance: 20)
    matches_resource(job, distance: 20)
  end

  def admin?
    true
  end
end

# == Schema Information
#
# Table name: users
#
#  id          :integer          not null, primary key
#  name        :string
#  email       :string
#  phone       :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  latitude    :float
#  longitude   :float
#  address     :string
#
