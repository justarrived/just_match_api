# frozen_string_literal: true
class MessageUsers
  def self.call(users:, template:)
    users.each do |user|
      begin
        message = template % user.attributes.symbolize_keys
      rescue KeyError => e
        return { success: false, message: "Unknown key: '#{e.message}'" }
      end

      if user.phone
        from = ENV.fetch('TWILIO_NUMBER') # NOTE: don't use ENV like this, refactor
        TexterJob.perform_later(from: from, to: user.phone, body: message)
      end
    end

    { success: true, message: "Sending SMS to #{users.length} user(s)." }
  end
end
