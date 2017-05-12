# frozen_string_literal: true

module ErrorNotifier
  def self.send(message, exception: nil, context: {}, client: Airbrake)
    error_context = context.dup
    error_context[:reraised_exception] = true
    if exception
      error_class = exception.class.to_s
      error_context[:error_class] = error_class
      error_context[:error_message] = exception.message
      error_context[:error_backtrace] = exception.backtrace.join("\n")
    end
    client.notify(message, error_context)
  end
end
