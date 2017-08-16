# frozen_string_literal: true

FactoryGirl.define do
  factory :occupation do
    name 'MyString'
  end
end

# == Schema Information
#
# Table name: occupations
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
#  index_occupatuions_on_ancestry     (ancestry)
#  index_occupatuions_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#
