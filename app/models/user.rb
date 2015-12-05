class User < ActiveRecord::Base
  include Geocodable
  has_many :user_skills, inverse_of: :user
  has_many :skills, through: :user_skills

  has_many :job_users
  has_many :jobs, through: :job_users

  validates_presence_of :email
  # TODO: Validates format of email
  # validates :email, email: true, allow_blank: false
  validates :name, length: { minimum: 3 }, allow_blank: false
  validates :phone, length: { minimum: 9 }, allow_blank: false
  validates :description, length: { minimum: 10 }, allow_blank: false
  validates :address, length: { minimum: 2 }, allow_blank: false

  def self.matches_job(job, distance: 20)
    job_skills = job.skills.pluck(:id)
    matching_users = []

    # TODO: The below causes N+1 SQL
    within(lat: job.latitude, long: job.longitude, distance: distance)
      .joins(:user_skills)
      .where('user_skills.skill_id IN (?)', job_skills)
      .distinct
      .each do |user|
      byebug if user.nil?
      if all_match?(user.skills.pluck(:id), job_skills)
        matching_users << user
      end
    end
    matching_users
  end

  private

  def self.all_match?(first_array, second_array)
    (first_array & second_array).length == second_array.length
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
