# frozen_string_literal: true
require 'seeds/dev/category_seed'
require 'seeds/dev/chat_seed'
require 'seeds/dev/company_seed'
require 'seeds/dev/job_seed'
require 'seeds/dev/job_user_seed'
require 'seeds/dev/skill_seed'
require 'seeds/dev/user_seed'

namespace :dev do
  task count_models: :environment do
    ignore_tables = %w(
      schema_migrations blazer_dashboards blazer_audits blazer_checks
      blazer_dashboard_queries blazer_queries
    )
    (ActiveRecord::Base.connection.tables - ignore_tables).map do |table|
      model_name = table.capitalize.singularize.camelize
      model_klass = model_name.constantize

      fill_count = 15 - model_name.length
      first_part = "#{model_name}#{' ' * fill_count}"

      puts "#{first_part}#{model_klass.count}"
    end
  end

  SEED_ADDRESSES = [
    { street: "Stora Nygatan #{Random.rand(1..40)}", zip: '21137' },
    { street: "Wollmar Yxkullsgatan #{Random.rand(1..40)}", zip: '11850' }
  ].freeze

  task seed: :environment do
    %w(categories companies skills users jobs chats job_users).each do |task|
      Rake::Task["dev:seed:#{task}"].execute
    end
  end

  namespace :seed do
    task categories: :environment do
      Dev::CategorySeed.call
    end

    task companies: :environment do
      Dev::CompanySeed.call
    end

    task skills: :environment do
      Dev::SkillSeed.call
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
      Dev::ChatSeed.call(users: users)
    end

    task job_users: :environment do
      jobs = Job.all
      users = User.all
      Dev::JobUserSeed.call(jobs: jobs, users: users)
    end
  end

  task doc_examples: :environment do
    fail 'Can only generate docs when Rails is in test mode.' unless Rails.env.test?
    Doxxer.generate_response_examples
  end
end
