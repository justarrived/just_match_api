# Development seed

def max_count_opt(env_name, default)
  ENV.fetch(env_name, default).to_i
end

# Allow caller to define how many resources are created
max_langs           = max_count_opt('MAX_LANGS', 5)
max_skills          = max_count_opt('MAX_SKILLS', 10)
max_users           = max_count_opt('MAX_USERS', 10)
max_jobs            = max_count_opt('MAX_JOBS', 10)
max_job_users       = max_count_opt('MAX_JOB_USERS', 10)
max_chats           = max_count_opt('MAX_CHATS', 10)
max_job_comments    = max_count_opt('MAX_JOB_COMMENTS', 10)
max_chat_messages   = max_count_opt('MAX_CHAT_MESSAGES', 10)

puts '[db:seed] Language'
lang_codes = %w(en sv de dk no fi pl es fr hu)
max_langs.times do
  Language.create!(lang_code: lang_codes.sample)
end

languages = Language.all

puts '[db:seed] Skill'
max_skills.times do
  Skill.create!(name: Faker::Name.title, language: languages.sample)
end

puts '[db:seed] Address'
addresses = [
  { street: "Stora Nygatan #{Random.rand(1..40)}", zip: '21137' },
  { street: "Wollmar Yxkullsgatan #{Random.rand(1..40)}", zip: '11850' }
]

puts '[db:seed] Admin'
admin_address = addresses.sample
User.create!(
  name: Faker::Name.name,
  email: Faker::Internet.email,
  phone: Faker::PhoneNumber.cell_phone,
  description: Faker::Hipster.paragraph(2),
  street: admin_address[:street],
  zip: admin_address[:zip],
  language: languages.sample,
  password: (1..8).to_a.join,
  admin: true
)

puts '[db:seed] User'
skills = Skill.all
max_users.times do
  address = addresses.sample
  user = User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    phone: Faker::PhoneNumber.cell_phone,
    description: Faker::Hipster.paragraph(2),
    street: address[:street],
    zip: address[:zip],
    language: languages.sample,
    password: (1..8).to_a.join
  )
  user.skills << skills.sample
  user.languages << languages.sample
end

puts '[db:seed] Job'
days_from_now_range = (1..10).to_a
rates = (100..1000).to_a
users = User.all

max_jobs.times do
  address = addresses.sample
  hours = (1..10).to_a.sample
  job = Job.create!(
    name: Faker::Name.name,
    max_rate: rates.sample,
    description: Faker::Hipster.paragraph(2),
    job_date: days_from_now_range.sample.days.from_now,
    owner: users.sample,
    street: address[:street],
    zip: address[:zip],
    hours: hours,
    language: languages.sample
  )
  job.skills << skills.sample
  Random.rand(1..max_job_comments).times do
    Comment.create!(
      body: Faker::Company.bs,
      owner_user_id: users.sample.id,
      commentable: users.sample,
      language: languages.sample
    )
  end
end

puts '[db:seed] Job user'
jobs = Job.all
max_job_users.times do |current_iteration|
  job = jobs.sample
  owner = job.owner

  user = users.sample
  max_retries = 5
  until owner != user
    user = users.sample
    max_retries += 1
    break if max_retries < 1
  end

  job = jobs.sample
  JobUser.create(
    user: user,
    job: job,
    rate: rates.sample
  )
  # Accept one user as accepted applicant
  if current_iteration == max_job_users - 1
    job.accept_applicant!(user)
  end
end

puts '[db:seed] Chat'
max_chats.times do
  user = users.sample
  other_user = (users - [user]).sample
  user_ids = User.where(id: [user.id, other_user.id])
  chat = Chat.find_or_create_private_chat(user_ids)
  Random.rand(1..max_chat_messages).times do
    author = [user, other_user].sample
    Message.create!(body: Faker::Hipster.paragraph(2), chat: chat, author: author)
  end
end
