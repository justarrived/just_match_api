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

  # $ rails frilans_finans:parse_log['tmp/test_file.txt']
  task :parse_log, [:filename] do |_t, args|
    require 'frilans_finans_api/parse_log'

    puts FrilansFinansAPI::ParseLog.call(args.fetch(:filename)).inspect
  end
end
