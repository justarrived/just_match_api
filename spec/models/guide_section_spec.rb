# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GuideSection, type: :model do
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
