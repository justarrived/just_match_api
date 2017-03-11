# frozen_string_literal: true
require 'seeds/base_seed'

module Dev
  class UserSeed < BaseSeed
    def self.call(languages:, skills:, addresses:, companies:, tags:, interests:)
      max_users = max_count_opt('MAX_USERS', 50)
      max_company_users = max_count_opt('MAX_COMPANY_USERS', 5)

      Faker::Config.locale = 'sv'

      system_languages = languages.system_languages

      log_seed(User, UserSkill, UserLanguage, UserInterest) do
        log 'Creating Admin user'
        create_user(
          email: 'admin@example.com',
          admin: true,
          super_admin: true,
          address: addresses.sample,
          language: system_languages.sample
        )

        log 'Creating Users'
        max_users.times do
          user = create_user(
            address: addresses.sample,
            language: system_languages.sample,
            tags: tags,
            interests: interests
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

    def self.create_user(address:, language:, email: nil, admin: false, company: nil, tags: nil, interests: nil) # rubocop:disable Metrics/LineLength
      email_address = email || "#{SecureGenerator.token(length: 4)}@example.com"
      user = User.find_or_initialize_by(email: email_address)

      user.assign_attributes(
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        phone: Faker::PhoneNumber.cell_phone,
        street: address[:street],
        zip: address[:zip],
        language: language,
        password: '12345678',
        admin: admin,
        super_admin: admin,
        company: company,
        just_arrived_staffing: company && Random.rand(10) == 9 ? true : false
      )
      user.save
      user.set_translation(
        description: Faker::Hipster.paragraph(2),
        job_experience: Faker::Hipster.paragraph(2),
        education: Faker::Hipster.paragraph(2),
        competence_text: Faker::Hipster.paragraph(2)
      )
      if tags
        UserTag.safe_create(tag: tags.sample, user: user)
        UserTag.safe_create(tag: tags.sample, user: user) if Random.rand(2) == 1
      end

      if interests
        UserInterest.
          find_or_initialize_by(user: user, interest: interests.sample).
          tap do |user_interest|

          user_interest.level = Random.rand(5) + 1
          user_interest.level_by_admin = Random.rand(5) + 1
          user_interest.save
        end
      end
      user
    end
  end
end
