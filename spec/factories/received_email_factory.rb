# frozen_string_literal: true

FactoryBot.define do
  factory :received_email do
    from_address 'MyString'
    to_address 'MyString'
    subject 'MyString'
    text_body 'MyText'
    html_body 'MyText'
  end
end

# == Schema Information
#
# Table name: received_emails
#
#  id           :integer          not null, primary key
#  from_address :string
#  to_address   :string
#  subject      :string
#  text_body    :text
#  html_body    :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
