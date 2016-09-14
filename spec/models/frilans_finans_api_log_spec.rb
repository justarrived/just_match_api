# frozen_string_literal: true
require 'rails_helper'

RSpec.describe FrilansFinansApiLog, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: frilans_finans_api_logs
#
#  id            :integer          not null, primary key
#  status        :integer
#  status_name   :string
#  params        :text
#  response_body :text
#  uri           :string(2083)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
