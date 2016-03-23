require 'rspec/expectations'

RSpec::Matchers.define :match_email_body do |expected|
  match do |mail|
    %w(text html).map do |part|
      mail.public_send("#{part}_part").body.to_s.include?(expected)
    end.all? { |e| e == true }
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

RSpec::Matchers.define :be_multipart_email do |expected|
  match do |mail|
    mail.multipart? == expected
  end

  failure_message do |mail|
    negate = ''
    negate = 'not ' if expected == false
    "expected mail #{negate}to be multipart"
  end
end
