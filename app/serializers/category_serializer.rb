# frozen_string_literal: true
class CategorySerializer < ApplicationSerializer
  ATTRIBUTES = [:name].freeze

  attributes ATTRIBUTES

  link(:self) { api_v1_category_url(object) }
end

# == Schema Information
#
# Table name: categories
#
#  id                :integer          not null, primary key
#  name              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  frilans_finans_id :integer
#  insurance_status  :integer
#
# Indexes
#
#  index_categories_on_frilans_finans_id  (frilans_finans_id) UNIQUE
#  index_categories_on_name               (name) UNIQUE
#
