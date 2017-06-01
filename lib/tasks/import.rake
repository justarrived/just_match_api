# frozen_string_literal: true

require 'import/wgtrm/import'
require 'import/wgtrm/import_resumes'

namespace :import do
  task wgtrm: :environment do
    %w(users resumes).each { |task| Rake::Task["import:wgtrm:#{task}"].execute }
  end

  namespace :wgtrm do
    task users: :environment do
      import = Wgtrm::Import.perform(ignore_emails: [])

      puts "[import:wgtrm] Users          : #{import.users.length}"
      puts "[import:wgtrm] User tags      : #{import.user_tags.length}"
      puts "[import:wgtrm] User languages : #{import.user_languages.length}"
      puts "[import:wgtrm] User interests : #{import.user_interests.length}"
    end

    task resumes: :environment do
      import_resumes = Wgtrm::ImportResumes.perform
      puts "[import:wgtrm] User Resumes   : #{import_resumes.length}"
    end
  end
end
