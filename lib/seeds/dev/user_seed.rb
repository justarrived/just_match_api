# frozen_string_literal: true
require 'seeds/dev/base_seed'

module Dev
  class UserSeed < BaseSeed
    def self.call(languages:, skills:, addresses:, companies:)
      max_users = max_count_opt('MAX_USERS', 50)
      max_company_users = max_count_opt('MAX_COMPANY_USERS', 5)

      system_languages = languages.system_languages

      log '[db:seed] Admin user'
      create_user(
        email: 'admin@example.com',
        admin: true,
        address: addresses.sample,
        language: system_languages.sample
      )

      log '[db:seed] User'
      max_users.times do
        user = create_user(
          address: addresses.sample,
          language: system_languages.sample
        )
        user.skills << skills.sample
        user.languages << languages.sample
      end

      log '[db:seed] Company User'
      max_company_users.times do
        company = companies.sample
        create_user(
          address: addresses.sample,
          language: system_languages.sample,
          company: company
        )
      end
    end

    def self.create_user(address:, language:, email: nil, admin: false, company: nil)
      User.create!(
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        email: email || Faker::Internet.email,
        phone: Faker::PhoneNumber.cell_phone,
        description: Faker::Hipster.paragraph(2),
        street: address[:street],
        zip: address[:zip],
        language: language,
        password: (1..8).to_a.join,
        ssn: Faker::Number.number(10),
        admin: admin,
        company: company
      )
    end
  end
end
