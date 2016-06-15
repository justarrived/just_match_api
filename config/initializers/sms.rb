# frozen_string_literal: true

unless Rails.configuration.x.send_sms_notifications
  SMSClient.client = FakeSMS
end
