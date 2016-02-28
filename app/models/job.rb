# frozen_string_literal: true
class Job < ActiveRecord::Base
  include Geocodable
  include SkillMatchable

  LOCATE_BY = {
    address: { lat: :latitude, long: :longitude },
    zip: { lat: :zip_latitude, long: :zip_longitude }
  }.freeze

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
  validates :street, length: { minimum: 5 }, allow_blank: false
  validates :zip, length: { minimum: 5 }, allow_blank: false
  validates :job_date, presence: true
  validates :owner, presence: true
  validates :hours, numericality: { greater_than_or_equal_to: 1 }, allow_blank: false

  belongs_to :owner, class_name: 'User', foreign_key: 'owner_user_id'

  def self.matches_user(user, distance: 20, strict_match: false)
    lat = user.latitude
    long = user.longitude

    within(lat: lat, long: long, distance: distance).
      order_by_matching_skills(user, strict_match: strict_match)
  end

  # Needed for administrate
  # see https://github.com/thoughtbot/administrate/issues/354
  def owner_id
    owner.try!(:id)
  end

  # Needed for administrate
  # see https://github.com/thoughtbot/administrate/issues/354
  def owner_id=(id)
    self.owner = User.find(id)
  end

  def owner?(user)
    !owner.nil? && owner == user
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

  def find_applicant(user)
    job_users.find_by(user: user)
  end

  def accepted_applicant?(user)
    !accepted_applicant.nil? && accepted_applicant == user
  end

  def accepted_applicant
    job_users.find_by(accepted: true).try!(:user)
  end

  def accept_applicant!(user)
    applicants.find_by(user: user).tap do |applicant|
      applicant.accept
      applicant.save!
    end
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
#  id               :integer          not null, primary key
#  max_rate         :integer
#  description      :text
#  job_date         :datetime
#  performed_accept :boolean          default(FALSE)
#  performed        :boolean          default(FALSE)
#  hours            :float
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  owner_user_id    :integer
#  latitude         :float
#  longitude        :float
#  name             :string
#  language_id      :integer
#  street           :string
#  zip              :string
#  zip_latitude     :float
#  zip_longitude    :float
#
# Indexes
#
#  index_jobs_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_70cb33aa57    (language_id => languages.id)
#  jobs_owner_user_id_fk  (owner_user_id => users.id)
#
