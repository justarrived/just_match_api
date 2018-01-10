# frozen_string_literal: true

class Occupation < ApplicationRecord
  has_ancestry

  belongs_to :language

  scope :order_by_name, (lambda { |direction: :asc|
    dir = direction.to_s == 'desc' ? 'DESC' : 'ASC'
    order("occupation_translations.name #{dir}")
  })

  include Translatable
  translates :name

  def display_name
    "##{id} #{name}"
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
#  index_occupations_on_ancestry     (ancestry)
#  index_occupations_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#
