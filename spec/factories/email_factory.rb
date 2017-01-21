# frozen_string_literal: true
FactoryGirl.define do
  factory :email, class: OpenStruct do
    to [{
      raw: 'to@example.com',
      email: 'to@example.com',
      token: 'to',
      host: 'example.com'
    }]
    from 'from@example.com'
    subject 'email subject'
    body 'Hello!'
    attachments { [] }
  end
end
