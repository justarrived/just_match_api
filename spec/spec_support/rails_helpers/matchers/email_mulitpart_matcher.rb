# frozen_string_literal: true

require 'rspec/expectations'

RSpec::Matchers.define :match_email_body do |expected|
  match do |mail|
    has_contents = %w(text html).map do |part|
      mail.public_send("#{part}_part").body.to_s.include?(expected)
    end
    has_contents.all? { |e| e == true }
  end

  failure_message do |mail|
    message_parts = []
    %w(text html).map do |part|
      mail_contents = mail.public_send("#{part}_part").body.to_s
      worked = mail_contents.include?(expected)
      fail_msg = "expected that #{mail_contents} would include #{expected}"
      message_parts << fail_msg unless worked
    end
    message_parts.join("\n and \n")
  end
end

RSpec::Matchers.define :match_email_body_html do |expected|
  match do |mail|
    mail.html_part.body.to_s.include?(expected) == true
  end

  failure_message do |mail|
    mail_contents = mail.public_send(html_part).body.to_s
    fail_msg = "expected that #{mail_contents} would include #{expected}"
    fail_msg unless mail_contents.include?(expected)
  end
end

RSpec::Matchers.define :match_email_body_text do |expected|
  match do |mail|
    mail.text_part.body.to_s.include?(expected) == true
  end

  failure_message do |mail|
    mail_contents = mail.public_send(text_part).body.to_s
    fail_msg = "expected that #{mail_contents} would include #{expected}"
    fail_msg unless mail_contents.include?(expected)
  end
end

RSpec::Matchers.define :be_multipart_email do |expected|
  match do |mail|
    mail.multipart? == expected
  end

  failure_message do |_mail|
    negate = ''
    negate = 'not ' if expected == false
    "expected mail #{negate}to be multipart"
  end
end
