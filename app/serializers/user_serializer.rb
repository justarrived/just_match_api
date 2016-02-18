# frozen_string_literal: true
class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :phone, :description, :created_at, :street,
             :zip, :zip_latitude, :zip_longitude

  has_one :language

  has_many :languages
  has_many :written_comments
  has_many :skills
  has_many :jobs
end

# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  name          :string
#  email         :string
#  phone         :string
#  description   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  latitude      :float
#  longitude     :float
#  language_id   :integer
#  anonymized    :boolean          default(FALSE)
#  auth_token    :string
#  password_hash :string
#  password_salt :string
#  admin         :boolean          default(FALSE)
#  street        :string
#  zip           :string
#
# Indexes
#
#  index_users_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_45f4f12508  (language_id => languages.id)
#
