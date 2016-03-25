# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Contact, type: :model do
end

# == Schema Information
#
# Table name: contacts
#
#  id         :integer          not null, primary key
#  name       :string
#  email      :string
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
