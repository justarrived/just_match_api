# frozen_string_literal: true

class DeliverNotification
  def self.call(envelope, locale = I18n.default_locale)
    envelope.deliver_later
  rescue Redis::ConnectionError, Redis::CannotConnectError => e
    ErrorNotifier.send(e, context: { locale: locale })
    # Retry the block but skip Redis and deliver it synchronously instead
    envelope.deliver_now
  end
end
