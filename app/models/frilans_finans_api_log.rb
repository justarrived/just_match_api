# frozen_string_literal: true

class FrilansFinansApiLog < ApplicationRecord
  scope :unproccessable_entity, (-> { where(status: 422) })
  scope :server_error, (-> { where(status: 500) })
  scope :created, (-> { where(status: 201) })
  scope :success, (-> { where(status: 200) })
end

# == Schema Information
#
# Table name: frilans_finans_api_logs
#
#  id            :integer          not null, primary key
#  status        :integer
#  status_name   :string
#  verb          :string
#  params        :text
#  response_body :text
#  uri           :string(2083)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
