# frozen_string_literal: true
require 'import/wgtrm/import'

namespace :import do
  task wgtrm: :environment do
    import = Wgtrm::Import.perform(ignore_emails: [])

    puts "[import:wgtrm] Users          : #{import.users.length}"
    puts "[import:wgtrm] User tags      : #{import.user_tags.length}"
    puts "[import:wgtrm] User languages : #{import.user_languages.length}"
    puts "[import:wgtrm] User interests : #{import.user_interests.length}"
  end
end
