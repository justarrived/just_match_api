# frozen_string_literal: true

FactoryGirl.define do
  factory :language_filter do
    association :filter
    association :language
    proficiency 1
    proficiency_by_admin 1
  end
end

# == Schema Information
#
# Table name: language_filters
#
#  id                   :integer          not null, primary key
#  filter_id            :integer
#  language_id          :integer
#  proficiency          :integer
#  proficiency_by_admin :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_language_filters_on_filter_id    (filter_id)
#  index_language_filters_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_39bd0771e8              (filter_id => filters.id)
#  language_filters_language_id_fk  (language_id => languages.id)
#
