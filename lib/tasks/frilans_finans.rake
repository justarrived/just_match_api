# frozen_string_literal: true
namespace :frilans_finans do
  task import: :environment do
    %w(currencies professions).each do |task|
      Rake::Task["frilans_finans:import:#{task}"].execute
    end
  end

  namespace :import do
    task currencies: :environment do
      FrilansFinansImporter.currencies
    end

    task professions: :environment do
      FrilansFinansImporter.professions
    end
  end
end
