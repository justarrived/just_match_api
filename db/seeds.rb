# Development seed

# Seed skills
5.times do
  Skill.create(name: Faker::Name.title)
end

address = []
15.times do |i|
  address << "Tomegapsgatan #{i}"
  address << "Wollmar Yxkullsgatan #{i}"
end

# Seed users
skills = Skill.all
10.times do
  user = User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    phone: Faker::PhoneNumber.cell_phone,
    description: Faker::Hipster.paragraph(2),
    address: address.sample,
  )
user.skills << skills.sample
end

# Seed jobs
days_from_now_range = (1..10).to_a
rates = (100..1000).to_a
users = User.all

10.times do
  job = Job.create!(
    name: Faker::Name.name,
    max_rate: rates.sample,
    description: Faker::Hipster.paragraph(2),
    job_date: (days_from_now_range.sample).days.from_now,
    owner: users.sample,
    address: address.sample
  )
  job.skills << skills.sample
end

# Seed job users
jobs = Job.all
2.times do
  job = jobs.sample
  owner = job.owner

  user = users.sample
  user = users.sample until owner != user

  job = jobs.sample
  JobUser.create!(
    user: user,
    job: job,
    rate: rates.sample,
  )
end
