# frozen_string_literal: true
require 'migrate_data/migrate_translations'

namespace :migrate_data do
  task translations: :environment do
  end

  namespace :translations do
    task up: :environment do
      MigrateTranslations.up
    end

    task down: :environment do
      MigrateTranslations.down
    end
  end
end
