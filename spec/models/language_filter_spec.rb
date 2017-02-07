# frozen_string_literal: true
require 'rails_helper'

RSpec.describe LanguageFilter, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
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
#  fk_rails_39bd0771e8  (filter_id => filters.id)
#
