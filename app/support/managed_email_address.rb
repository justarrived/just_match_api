# frozen_string_literal: true

module ManagedEmailAddress
  def self.call(email:, id:)
    email_username = ENV.fetch('MANAGED_EMAIL_USERNAME', nil)
    email_hostname = ENV.fetch('MANAGED_EMAIL_HOSTNAME', nil)

    return email if email_username.blank? || email_hostname.blank?

    # NOTE: This will only work properly with Gmail or Google Apps,
    #       the "+" sign is special..
    "#{email_username.strip}+#{id}@#{email_hostname.strip}"
  end
end
