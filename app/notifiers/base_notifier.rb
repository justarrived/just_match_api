# frozen_string_literal: true
class BaseNotifier
  def self.ignored?(user, name = nil)
    notification_name = (name || underscored_name).to_s
    user.ignored_notification?(notification_name)
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
