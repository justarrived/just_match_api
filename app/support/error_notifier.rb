# frozen_string_literal: true
module ErrorNotifier
  def self.send(message, context: {}, client: Airbrake)
    client.notify(message, context)
  end
end
