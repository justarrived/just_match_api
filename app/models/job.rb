class Job < ActiveRecord::Base
  has_many :job_skills, inverse_of: :job
  has_many :skills, through: :job_skills

  has_many :job_users
  has_many :users, through: :job_users

  validates :max_rate, numericality: { only_integer: true }, allow_blank: false
  validates :description, length: { minimum: 10 }, allow_blank: false
  validates :address, length: { minimum: 2 }, allow_blank: false
  # TODO: Validate #job_date format?

  validates_presence_of :owner

  belongs_to :owner, class_name: 'User', foreign_key: 'owner_user_id'

  geocoded_by :full_street_address   # can also be an IP address
  after_validation :geocode,
    if: ->(user){ user.address_changed? }          # auto-fetch coordinates if address changed

  def full_street_address
    address
  end
  
  # NOTE: You need to call this __before__ the record is saved/updated
  #       otherwise it will always return false
  def send_performed_notice?
    performed_changed? && performed
  end

  def job_user
    job_users.find_by(accepted: true)
  end
end

# == Schema Information
#
# Table name: jobs
#
#  id            :integer          not null, primary key
#  max_rate      :integer
#  description   :text
#  job_date      :datetime
#  performed     :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  owner_user_id :integer
#  latitude      :float
#  longitude     :float
#  address       :string
#
