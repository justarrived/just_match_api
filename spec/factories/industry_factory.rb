# frozen_string_literal: true

FactoryGirl.define do
  factory :industry do
    name 'MyString'
  end
end

# == Schema Information
#
# Table name: industries
#
#  id          :integer          not null, primary key
#  name        :string
#  ancestry    :string
#  language_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_industries_on_ancestry     (ancestry)
#  index_industries_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#
