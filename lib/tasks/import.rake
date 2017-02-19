# frozen_string_literal: true
require 'import/wgtrm/import'

namespace :import do
  task wgtrm: :environment do
    import = Wgtrm::Import.perform(ignore_emails: [])

    puts "Users          : #{import.users.length}"
    puts "User tags      : #{import.user_tags.length}"
    puts "User languages : #{import.user_languages.length}"
    puts "User interests : #{import.user_interests.length}"
  end
end
