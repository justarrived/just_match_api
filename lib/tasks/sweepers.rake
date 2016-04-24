# frozen_string_literal: true
namespace :sweepers do
  task applicant_confirmation_overdue: :environment do |task_name|
    wrap_sweeper_task(task_name) do
      Sweepers::JobUserSweeper.applicant_confirmation_overdue
    end
  end

  task frilans_finans: :environment do |task_name|
    wrap_sweeper_task(task_name) do
      Sweepers::CompanySweeper.create_frilans_finans
    end
  end

  def wrap_sweeper_task(task_name)
    uuid = SecureRandom.uuid
    Rails.logger.info "[Sweepers] Running: #{task_name} #{uuid}"
    yield(uuid)
    Rails.logger.info "[Sweepers] Done: #{task_name} #{uuid}"
  end
end
