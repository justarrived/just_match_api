# frozen_string_literal: true
namespace :sweepers do
  task applicant_confirmation_overdue: :environment do
    puts Sweepers::JobUserSweeper.applicant_confirmation_overdue
  end
end
