# frozen_string_literal: true

class FrilansFinansTerm < ApplicationRecord
  scope :user_terms, (-> { where(company: false) })
  scope :company_terms, (-> { where(company: true) })

  def self.current_user_terms
    user_terms.last
  end

  def self.current_company_user_terms
    company_terms.last
  end
end

# == Schema Information
#
# Table name: frilans_finans_terms
#
#  id         :integer          not null, primary key
#  body       :text
#  company    :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
