# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

5.times do
  Skill.create(name: Faker::Name.title)
end

skills = Skill.all
2.times do
  user = User.create(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    phone: Faker::PhoneNumber.cell_phone,
    description: Faker::Hipster.paragraph(2)
  )
  user.skills << skills.sample
end

days_from_now_range = (1..10).to_a
max_rates = (100..1000).to_a
5.times do
  job = Job.create(
    max_rate: max_rates.sample,
    description: Faker::Hipster.paragraph(2),
    job_date: (days_from_now_range.sample).days.from_now
  )
  job.skills << skills.sample
end
