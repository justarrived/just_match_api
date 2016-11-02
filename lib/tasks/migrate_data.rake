# frozen_string_literal: true
require 'migrate_data/migrate_translations'

namespace :migrate_data do
  namespace :translations do
    task up_with_google_translate: :environment do
      MigrateTranslations.up(google_translate: true)
    end

    task up: :environment do
      MigrateTranslations.up
    end

    task down: :environment do
      MigrateTranslations.down
    end
  end
end
