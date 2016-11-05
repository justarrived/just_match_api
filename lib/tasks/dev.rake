# frozen_string_literal: true
require 'seeds/dev/chat_seed'
require 'seeds/dev/company_seed'
require 'seeds/dev/faq_seed'
require 'seeds/dev/frilans_finans_term_seed'
require 'seeds/dev/invoice_seed'
require 'seeds/dev/job_seed'
require 'seeds/dev/job_user_seed'
require 'seeds/dev/skill_seed'
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

  SEED_ADDRESSES = [
    { street: "Stora Nygatan #{Random.rand(1..40)}", zip: '21137' },
    { street: "Wollmar Yxkullsgatan #{Random.rand(1..40)}", zip: '11850' }
  ].freeze

  task seed: :environment do
    %w(
      companies skills users jobs chats job_users invoices faqs frilans_finans_terms
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

    task frilans_finans_terms: :environment do
      Dev::FrilansFinansTermSeed.call
    end

    task terms_agreements: :environment do
      frilans_finans_terms = FrilansFinansTerm.all
      Dev::TermsAgreementSeed.call(frilans_finans_terms: frilans_finans_terms)
    end

    task users: :environment do
      languages = Language.all
      skills = Skill.all
      companies = Company.all
      Dev::UserSeed.call(
        languages: languages,
        skills: skills,
        addresses: SEED_ADDRESSES,
        companies: companies
      )
    end

    task jobs: :environment do
      languages = Language.all
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
      languages = Language.all
      Dev::ChatSeed.call(users: users, languages: languages)
    end

    task job_users: :environment do
      jobs = Job.all
      users = User.regular_users
      Dev::JobUserSeed.call(jobs: jobs, users: users)
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

  task doc_examples: :environment do
    fail 'Can only generate docs when Rails is in docs env.' unless Rails.env.docs?

    %w(drop create schema:load).each { |task| Rake::Task["db:#{task}"].invoke }

    Doxxer.generate_response_examples
  end
end
