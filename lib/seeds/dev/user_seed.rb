# frozen_string_literal: true
require 'seeds/dev/base_seed'

class UserSeed < BaseSeed
  def self.call(languages:, skills:, addresses:)
    max_users = max_count_opt('MAX_USERS', 50)

    log '[db:seed] Admin user'
    admin_address = addresses.sample
    User.create!(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: 'admin@example.com',
      phone: Faker::PhoneNumber.cell_phone,
      description: Faker::Hipster.paragraph(2),
      street: admin_address[:street],
      zip: admin_address[:zip],
      language: languages.sample,
      password: (1..8).to_a.join,
      ssn: Faker::Number.number(10),
      admin: true
    )

    log '[db:seed] User'
    max_users.times do
      address = addresses.sample
      user = User.create!(
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        email: Faker::Internet.email,
        phone: Faker::PhoneNumber.cell_phone,
        description: Faker::Hipster.paragraph(2),
        street: address[:street],
        zip: address[:zip],
        language: languages.sample,
        password: (1..8).to_a.join,
        ssn: Faker::Number.number(10)
      )
      user.skills << skills.sample
      user.languages << languages.sample
    end
  end
end
