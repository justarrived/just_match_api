# frozen_string_literal: true

class GuideSection < ApplicationRecord
  belongs_to :language, optional: true

  has_many :articles, class_name: 'GuideSectionArticle', dependent: :destroy

  include Translatable
  translates :title, :short_description, :slug

  def display_name
    "##{id} #{title || self.class.name}"
  end
end

# == Schema Information
#
# Table name: guide_sections
#
#  id          :bigint(8)        not null, primary key
#  order       :integer
#  language_id :bigint(8)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_guide_sections_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#
