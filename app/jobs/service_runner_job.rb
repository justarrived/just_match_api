# frozen_string_literal: true

class ServiceRunnerJob < ApplicationJob
  def perform(service, *args, **keyword_args)
    service.constantize.call(*args, **keyword_args)
  end
end
