# frozen_string_literal: true
namespace :sweepers do
  task applicant_confirmation_overdue: :environment do |task_name|
    Rails.logger.info "[Sweepers] Running: #{task_name}"
    Sweepers::JobUserSweeper.applicant_confirmation_overdue
    Rails.logger.info "[Sweepers] Done: #{task_name}"
  end
end
