# frozen_string_literal: true

FactoryGirl.define do
  factory :frilans_finans_api_log do
    status 1
    status_name 'MyString'
    params 'MyText'
    response_body ''
    uri 'MyText'
  end
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
