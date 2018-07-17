# frozen_string_literal: true

FactoryBot.define do
  factory :frilans_finans_term do
    body 'Some text'
    company false
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
