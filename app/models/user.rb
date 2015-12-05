class User < ActiveRecord::Base
  include Geocodable
  geocoded_by :full_street_address
  has_many :user_skills, inverse_of: :user
  has_many :skills, through: :user_skills

  has_many :job_users
  has_many :jobs, through: :job_users

  # TODO: Validates format of email
  # validates :email, email: true, allow_blank: false
  validates :name, length: { minimum: 3 }, allow_blank: false
  validates :phone, length: { minimum: 9 }, allow_blank: false
  validates :description, length: { minimum: 10 }, allow_blank: false
  validates :address, length: { minimum: 2 }, allow_blank: false
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
