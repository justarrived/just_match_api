# frozen_string_literal: true

class ExecuteService
  def self.call(service_klass, *args, run_async: true, wait_duration: nil, **keyword_args)
    return service_klass.call(*args, **keyword_args) unless run_async

    ServiceRunnerJob.
      set(wait: wait_duration).
      perform_later(service_klass.to_s, *args, **keyword_args)
  end
end
