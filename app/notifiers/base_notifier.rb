# frozen_string_literal: true
class BaseNotifier
  def self.notify(envelope, user: nil, locale: I18n.locale, name: nil)
    with_locale(locale) do
      DeliverNotification.call(envelope, locale) unless ignored?(user, name)
    end
    true
  end

  def self.ignored?(user, notification_name = nil)
    name = (notification_name || underscored_name).to_s

    user&.ignored_notification?(name) || globally_ignored?(name)
  end

  def self.globally_ignored?(notification_name)
    AppConfig.globally_ignored_notifications.include?(notification_name)
  end

  def self.underscored_name
    to_s.chomp('Notifier').underscore
  end

  def self.with_locale(locale)
    previous_locale = I18n.locale
    I18n.locale = locale
    yield
    I18n.locale = previous_locale
  end
end
