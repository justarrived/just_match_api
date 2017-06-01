# frozen_string_literal: true

class DeliverNotification
  def self.call(envelope, locale)
    envelope.deliver_later
  rescue Redis::ConnectionError => e
    ErrorNotifier.send(e, context: { locale: locale })
    # Retry the block but skip Redis and deliver it synchronously instead
    envelope.deliver_now
  end
end
