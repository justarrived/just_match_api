# frozen_string_literal: true
class Company < ApplicationRecord
  has_many :users
  has_many :jobs, through: :users

  has_many :company_images

  validates :name, length: { minimum: 2 }, allow_blank: false
  validates :cin, uniqueness: true, length: { is: 10 }, allow_blank: false
  validates :email, presence: true
  validates :street, length: { minimum: 1 }, allow_blank: false
  validates :zip, length: { minimum: 1 }, allow_blank: false
  validates :city, length: { minimum: 1 }, allow_blank: false
  validates :frilans_finans_id, uniqueness: true, allow_nil: true

  validate :validate_website_with_protocol

  # Virtual attributes for Frilans Finans
  attr_accessor :user_frilans_finans_id, :country_name

  scope :needs_frilans_finans_id, lambda {
    where(frilans_finans_id: nil).
      joins(:users).where('users.frilans_finans_id IS NOT NULL')
  }

  def find_frilans_finans_user
    users.frilans_finans_users.first
  end

  def country_name
    'Sweden'
  end

  def logo_image_token=(token)
    return if token.blank?

    company_image = CompanyImage.find_by_one_time_token(token)
    self.company_images = [company_image] unless company_image.nil?
  end

  def validate_website_with_protocol
    return if website.nil? || url_starts_with_protocol?(website)

    errors.add(:website, I18n.t('errors.general.protocol_missing'))
  end

  private

  def url_starts_with_protocol?(url)
    url.starts_with?('http://') || url.starts_with?('https://')
  end
end

# == Schema Information
#
# Table name: companies
#
#  id                :integer          not null, primary key
#  name              :string
#  cin               :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  frilans_finans_id :integer
#  website           :string
#  email             :string
#  street            :string
#  zip               :string
#  city              :string
#  phone             :string
#
# Indexes
#
#  index_companies_on_cin                (cin) UNIQUE
#  index_companies_on_frilans_finans_id  (frilans_finans_id) UNIQUE
#
