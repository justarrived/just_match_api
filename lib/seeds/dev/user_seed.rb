# frozen_string_literal: true
require 'seeds/base_seed'

module Dev
  class UserSeed < BaseSeed
    def self.call(languages:, skills:, addresses:, companies:)
      max_users = max_count_opt('MAX_USERS', 50)
      max_company_users = max_count_opt('MAX_COMPANY_USERS', 5)

      system_languages = languages.system_languages

      log_seed(User, UserSkill, UserLanguage) do
        log 'Creating Admin user'
        create_user(
          email: 'admin@example.com',
          admin: true,
          address: addresses.sample,
          language: system_languages.sample
        )

        log 'Creating Users'
        max_users.times do
          user = create_user(
            address: addresses.sample,
            language: system_languages.sample
          )
          user.skills << skills.sample if skills.any?
          user.languages << languages.sample
        end

        log 'Creating Company Users'
        # Create one known company user for easier testing
        company = companies.sample
        create_user(
          address: addresses.sample,
          language: system_languages.sample,
          company: company,
          email: 'company@example.com'
        )

        max_company_users.times do
          company = companies.sample
          create_user(
            address: addresses.sample,
            language: system_languages.sample,
            company: company
          )
        end
      end
    end

    def self.create_user(address:, language:, email: nil, admin: false, company: nil)
      email_address = email || "#{SecureRandom.uuid}@example.com"
      user = User.find_or_initialize_by(email: email_address)

      user.assign_attributes(
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
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
      user.save!
      user
    end
  end
end
