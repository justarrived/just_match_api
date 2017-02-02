# frozen_string_literal: true
class LanguageFilter < ApplicationRecord
  belongs_to :filter
  belongs_to :language
end

# == Schema Information
#
# Table name: language_filters
#
#  id                   :integer          not null, primary key
#  filter_id            :integer
#  proficiency          :integer
#  proficiency_by_admin :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_language_filters_on_filter_id  (filter_id)
#
# Foreign Keys
#
#  fk_rails_39bd0771e8  (filter_id => filters.id)
#
