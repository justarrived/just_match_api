# frozen_string_literal: true
class AskForJobInformationJob < ApplicationJob
  def perform(job_user)
    AskForJobInformationNotifier.call(job_user: job_user)
  end
end
