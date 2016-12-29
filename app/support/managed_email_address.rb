# frozen_string_literal: true

module ManagedEmailAddress
  def self.call(email:, id:)
    email_username = AppConfig.managed_email_username
    email_hostname = AppConfig.managed_email_hostname

    return email if email_username.blank? || email_hostname.blank?

    # NOTE: This will only work properly with Gmail or Google Apps,
    #       the "+" sign is special..
    "#{email_username.strip}+#{id}@#{email_hostname.strip}"
  end
end
