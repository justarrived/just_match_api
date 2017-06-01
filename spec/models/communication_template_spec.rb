# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommunicationTemplate, type: :model do
end

# == Schema Information
#
# Table name: communication_templates
#
#  id          :integer          not null, primary key
#  language_id :integer
#  category    :string
#  subject     :string
#  body        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_communication_templates_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_53f2d7081e  (language_id => languages.id)
#
