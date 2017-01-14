# frozen_string_literal: true
class BaseNotifier
  def self.notify(user: nil, locale: I18n.locale, name: nil)
    I18n.with_locale(locale) { yield unless ignored?(user, name) }
    true
  rescue Redis::ConnectionError => e
    ErrorNotifier.send(e, context: { locale: locale })
    false
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
end
