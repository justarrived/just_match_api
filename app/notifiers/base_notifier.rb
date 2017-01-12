# frozen_string_literal: true
class BaseNotifier
  def self.notify(locale: I18n.locale)
    with_locale(locale) { yield }
  rescue Redis::ConnectionError => e
    ErrorNotifier.send(e, context: { locale: locale })
  end

  def self.ignored?(user)
    user.ignored_notification?(underscored_name) || globally_ignored?(underscored_name)
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
