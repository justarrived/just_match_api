# frozen_string_literal: true
require 'seeds/dev/chat_seed'
require 'seeds/dev/company_seed'
require 'seeds/dev/faq_seed'
require 'seeds/dev/frilans_finans_term_seed'
require 'seeds/dev/interest_seed'
require 'seeds/dev/invoice_seed'
require 'seeds/dev/job_seed'
require 'seeds/dev/job_user_seed'
require 'seeds/dev/skill_seed'
require 'seeds/dev/tag_seed'
require 'seeds/dev/terms_agreement_seed'
require 'seeds/dev/user_seed'

namespace :dev do
  task count_models: :environment do
    ignore_tables = %w(
      schema_migrations blazer_dashboards blazer_audits blazer_checks
      blazer_dashboard_queries blazer_queries ar_internal_metadata active_admin_comments
    )
    padding = 35
    counts = (ActiveRecord::Base.connection.tables - ignore_tables).map do |table|
      model_name = table.capitalize.singularize.camelize
      model_klass = model_name.constantize

      fill_count = padding - model_name.length
      first_part = "#{model_name}#{' ' * fill_count}"

      count = model_klass.count
      puts "#{first_part}#{count}"

      model_klass.count
    end
    total = 'Total'
    fill_count = padding - total.length
    total_first_part = "#{total}#{' ' * fill_count}"
    puts '-' * (padding + 4)
    puts "#{total_first_part}#{counts.sum}"
  end

  namespace :db do
    desc 'Download latest database dump from Heroku, import and anonymize it'
    task :heroku_import, [:heroku_app_name] => [:environment] do |_t, args|
      unless Rails.env.development?
        fail('This command must run with Rails using the development environment.')
      end

      heroku_app_name = args[:heroku_app_name]
      if heroku_app_name.blank?
        puts 'Example'
        puts '  $ bin/rails dev:db:heroku_import["your_heroku_app_name"]'
        fail('You must provide a Heroku app name')
      end

      db_dump_path = 'tmp/latest-heroku.dump'

      # Download DB backup from Heroku
      puts 'Starting download of latest Heroku DB backup'
      system("heroku pg:backups:download --app=#{heroku_app_name} --output=#{db_dump_path}") # rubocop:disable Metrics/LineLength
      puts "Latest Heroku DB backup saved to #{db_dump_path}"

      puts 'Dropping current database'
      Rake::Task['db:drop'].execute
      Rake::Task['db:create'].execute

      # Restore DB
      puts "Restoring the database from #{db_dump_path}. This may take a while.."
      system("pg_restore --no-owner -d just_match_development #{db_dump_path}")
      puts 'Database restored.'

      # Anonymize DB
      puts 'Anonymizing the database and making it secure for development use.'
      Rake::Task['dev:anonymize_database'].execute
      puts 'Anonymization finished. Database ready for development use.'
    end
  end

  desc 'Anonymize the database'
  task anonymize_database: :environment do
    fail('Can *not* anonymize database in production env!') if Rails.env.production?

    print "Destroying #{Invoice.count} invoices.."
    Invoice.destroy_all
    puts 'destroyed!'
    print "Destroying #{FrilansFinansInvoice.count} Frilans Finans Invoices.."
    FrilansFinansInvoice.destroy_all
    puts 'destoryed!'
    print 'Setting all user passwords to "12345678"..'
    User.update_all( # rubocop:disable Rails/SkipsModelValidations
      password_salt: '$2a$10$G5.OPRLyRAh.gWYsY6lhaO',
      password_hash: '$2a$10$G5.OPRLyRAh.gWYsY6lhaOWIRMicGMdU7DCDR3UTbnLTOufAqYZeG'
    )
    puts 'done!'
    print "Anonymizing #{User.count} users..."
    User.find_each(batch_size: 500).each(&:reset!)
    puts 'anonymized!'
    print 'Set admin user email to admin@example.com..'
    User.admins.first&.update(email: 'admin@example.com')
    puts 'done!'
    print "Anonymizing #{Company.count} companies..."
    Company.find_each(batch_size: 500).each do |company|
      company.name = Faker::Company.name
      company.cin = Faker::Company.swedish_organisation_number
      company.email = "#{SecureGenerator.token(length: 32)}@example.com"
      company.website = nil
      company.street = Faker::Address.street_address
      company.save(validate: false)
    end
    puts 'anonymized!'
  end

  SEED_ADDRESSES = [
    { street: "Stora Nygatan #{Random.rand(1..40)}", city: 'Malmö', zip: '21137' },
    { street: "Wollmar Yxkullsgatan #{Random.rand(1..40)}", city: 'Stockholm', zip: '11850' } # rubocop:disable Metrics/LineLength
  ].freeze

  task seed: :environment do
    %w(
      companies skills tags users jobs chats job_users invoices faqs frilans_finans_terms
      terms_agreements
    ).each do |task|
      Rake::Task["dev:seed:#{task}"].execute
    end
  end

  namespace :seed do
    task companies: :environment do
      Dev::CompanySeed.call
    end

    task skills: :environment do
      Dev::SkillSeed.call
    end

    task interests: :environment do
      Dev::InterestSeed.call
    end

    task tags: :environment do
      Dev::TagSeed.call
    end

    task frilans_finans_terms: :environment do
      Dev::FrilansFinansTermSeed.call
    end

    task terms_agreements: :environment do
      frilans_finans_terms = FrilansFinansTerm.all
      Dev::TermsAgreementSeed.call(frilans_finans_terms: frilans_finans_terms)
    end

    task users: :environment do
      languages = Language.system_languages
      skills = Skill.all
      companies = Company.all
      tags = Tag.all
      interests = Interest.all
      Dev::UserSeed.call(
        languages: languages,
        skills: skills,
        addresses: SEED_ADDRESSES,
        companies: companies,
        tags: tags,
        interests: interests
      )
    end

    task jobs: :environment do
      languages = Language.system_languages
      skills = Skill.all
      users = User.company_users
      categories = Category.all
      hourly_pays = HourlyPay.active

      Dev::JobSeed.call(
        languages: languages,
        users: users,
        addresses: SEED_ADDRESSES,
        skills: skills,
        categories: categories,
        hourly_pays: hourly_pays
      )
    end

    task chats: :environment do
      users = User.all
      languages = Language.system_languages
      Dev::ChatSeed.call(users: users, languages: languages)
    end

    task job_users: :environment do
      jobs = Job.all
      users = User.regular_users
      languages = Language.system_languages
      Dev::JobUserSeed.call(jobs: jobs, users: users, languages: languages)
    end

    task invoices: :environment do
      job_users = JobUser.accepted
      Dev::InvoiceSeed.call(job_users: job_users)
    end

    task faqs: :environment do
      languages = Language.system_languages
      Dev::FaqSeed.call(languages: languages)
    end
  end
end
