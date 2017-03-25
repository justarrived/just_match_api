# frozen_string_literal: true
require 'migrate_data/migrate_translations'
require 'migrate_data/user_language_to_system_language'

namespace :migrate_data do
  namespace :translations do
    task up: :environment do
      MigrateTranslations.up
    end

    task down: :environment do
      MigrateTranslations.down
    end
  end

  namespace :user_language_to_system_language do
    desc 'Migrate User#language to User#system_language'
    task up: :environment do
      UserLanguageToSystemLanguage.up
    end
  end
end
