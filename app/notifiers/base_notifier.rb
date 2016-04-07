# frozen_string_literal: true
class BaseNotifier
  def self.ignored?(user)
    user.ignored_notification?(underscored_name)
  end

  def self.underscored_name
    to_s.chomp('Notifier').underscore
  end
end
