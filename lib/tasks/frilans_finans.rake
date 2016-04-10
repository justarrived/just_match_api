# frozen_string_literal: true
require 'frilans_finans_importer'

namespace :frilans_finans do
  task import: :environment do
    %w(professions).each do |task|
      Rake::Task["frilans_finans:import:#{task}"].execute
    end
  end

  namespace :import do
    task professions: :environment do
      # The API isn't live yet, so use a fixture client
      client = FrilansFinansApi::FixtureClient.new
      FrilansFinansImporter.professions(client: client)
    end
  end
end
