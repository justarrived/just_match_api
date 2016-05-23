# frozen_string_literal: true
namespace :sweepers do
  task applicant_confirmation_overdue: :environment do |task_name|
    wrap_sweeper_task(task_name) do
      Sweepers::JobUserSweeper.applicant_confirmation_overdue
    end
  end

  task cleanup: :environment do
    %w(destroy_company_image_orphans destroy_user_image_orphans).each do |task|
      Rake::Task["sweepers:cleanup:#{task}"].execute
    end
  end

  namespace :cleanup do
    task destroy_company_image_orphans: :environment do |task_name|
      wrap_sweeper_task(task_name) { Sweepers::CompanyImageSweeper.destroy_orphans }
    end

    task destroy_user_image_orphans: :environment do |task_name|
      wrap_sweeper_task(task_name) { Sweepers::UserImageSweeper.destroy_orphans }
    end
  end

  task frilans_finans: :environment do
    [
      :create_terms, :create_users, :create_companies, :create_invoices,
      :activate_invoices
    ].each do |task|
      Rake::Task["sweepers:frilans_finans:#{task}"].execute
    end
  end

  namespace :frilans_finans do
    task create_terms: :environment do |task_name|
      wrap_sweeper_task(task_name) do
        Sweepers::FrilansFinansTermSweeper.create_frilans_finans
      end
    end

    task create_users: :environment do |task_name|
      wrap_sweeper_task(task_name) do
        Sweepers::UserSweeper.create_frilans_finans
      end
    end

    task create_companies: :environment do |task_name|
      wrap_sweeper_task(task_name) do
        Sweepers::CompanySweeper.create_frilans_finans
      end
    end

    task create_invoices: :environment do |task_name|
      wrap_sweeper_task(task_name) do
        Sweepers::FrilansFinansInvoiceSweeper.create_frilans_finans
      end
    end

    task activate_invoices: :environment do |task_name|
      wrap_sweeper_task(task_name) do
        Sweepers::FrilansFinansInvoiceSweeper.activate_frilans_finans_invoices
      end
    end
  end

  def wrap_sweeper_task(task_name)
    uuid = SecureRandom.uuid
    Rails.logger.info "[Sweepers] Running: #{task_name} #{uuid}"
    yield(uuid)
    Rails.logger.info "[Sweepers] Done: #{task_name} #{uuid}"
  end
end
