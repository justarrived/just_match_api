# frozen_string_literal: true
class Contact
  include ActiveModel::Model

  attr_accessor :name, :email, :body

  validates :name, length: { minimum: 2 }, allow_blank: false
  validates :email, length: { minimum: 6 }, allow_blank: false
  validates :body, length: { minimum: 2 }, allow_blank: false
end
