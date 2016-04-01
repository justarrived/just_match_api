# frozen_string_literal: true
class Contact < ApplicationRecord
  validates :name, length: { minimum: 2 }, allow_blank: false
  validates :email, length: { minimum: 6 }, allow_blank: false
  validates :body, length: { minimum: 2 }, allow_blank: false
end

# == Schema Information
#
# Table name: contacts
#
#  id         :integer          not null, primary key
#  name       :string
#  email      :string
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
