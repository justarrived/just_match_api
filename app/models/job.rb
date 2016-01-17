class Job < ActiveRecord::Base
  include Geocodable
  include SkillMatchable

  belongs_to :language

  has_many :job_skills
  has_many :skills, through: :job_skills

  has_many :job_users
  has_many :users, through: :job_users

  has_many :comments, as: :commentable

  validates :language, presence: true
  validates :name, length: { minimum: 2 }, allow_blank: false
  validates :max_rate, numericality: { only_integer: true }, allow_blank: false
  validates :description, length: { minimum: 10 }, allow_blank: false
  validates :address, length: { minimum: 2 }, allow_blank: false
  validates :job_date, presence: true
  validates :owner, presence: true

  belongs_to :owner, class_name: 'User', foreign_key: 'owner_user_id'

  def self.matches_user(user, distance: 20, strict_match: false)
    lat = user.latitude
    long = user.longitude

    within(lat: lat, long: long, distance: distance).
      order_by_matching_skills(user, strict_match: strict_match)
  end

  # NOTE: You need to call this __before__ the record is saved/updated
  #       otherwise it will always return false
  def send_performed_accept_notice?
    performed_accept_changed? && performed_accept
  end

  # NOTE: You need to call this __before__ the record is saved/updated
  #       otherwise it will always return false
  def send_performed_notice?
    performed_changed? && performed
  end

  def accepted_applicant
    job_users.find_by(accepted: true).try!(:user)
  end

  def accept_applicant!(user)
    applicants.find_by(user: user).accept!
  end

  def create_applicant!(user)
    users << user
    user
  end

  def applicants
    job_users
  end
end

# == Schema Information
#
# Table name: jobs
#
#  id                        :integer          not null, primary key
#  max_rate                  :integer
#  description               :text
#  job_date                  :datetime
#  performed_accept          :boolean          default(FALSE)
#  performed                 :boolean          default(FALSE)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  owner_user_id             :integer
#  latitude                  :float
#  longitude                 :float
#  address                   :string
#  name                      :string
#  estimated_completion_time :float
#  language_id               :integer
#
# Indexes
#
#  index_jobs_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_70cb33aa57  (language_id => languages.id)
#
