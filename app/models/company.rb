# frozen_string_literal: true
class Company < ActiveRecord::Base
  has_many :users
  has_many :jobs, through: :users

  validates :name, uniqueness: true, length: { minimum: 2 }, allow_blank: false
  validates :cin, uniqueness: true, length: { is: 10 }, allow_blank: false
end

# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  name       :string
#  cin        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
