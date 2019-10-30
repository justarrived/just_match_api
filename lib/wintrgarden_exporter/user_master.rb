require 'csv'
require 'wintrgarden_exporter/base_exporter'
require 'wintrgarden_exporter/users'

#
# >>> Target CSV <<<
#
#
# >>> user <<<
# user_id first_name last_name ssn gender email phone street zip city
# country_of_origin arbetsformedlingen_registered_at linkedin_url
# created_at updated_at
#
# >>> tags <<<
# tag0 tag1 tag2 tag3 tag4
#
# >>> skills <<<
# skill0 skill1 skill2 skill3 skill4
# skill5 skill6 skill7 skill8 skill9
# skill_proficiency0 skill_proficiency1 skill_proficiency2 skill_proficiency3 skill_proficiency4
# skill_proficiency5 skill_proficiency6 skill_proficiency7 skill_proficiency8 skill_proficiency9
#
# >>> languages <<<
# language0 language1 language2 language3 language4
# language5 language6 language7 language8 language9
# language_proficiency0 language_proficiency1 language_proficiency2 language_proficiency3 language_proficiency4
# language_proficiency5 language_proficiency6 language_proficiency7 language_proficiency8 language_proficiency9
#
# >>> occupations <<<
# occupation0 occupation1 occupation2 occupation3 occupation4
# occupation5 occupation6 occupation7 occupation8 occupation9
# occupation_yeo0 occupation_yeo1 occupation_yeo2 occupation_yeo3 occupation_yeo4
# occupation_yeo5 occupation_yeo6 occupation_yeo7 occupation_yeo8 occupation_yeo9
#
# >>> Images <<<
# profile_image_file_name
#
# >>> CV <<<
# cv_file_name
#
# >>> Personal Letter <<<
# personal_letter_file_name
#
# >>> User comment <<<
# user_comment0 user_comment1 user_comment2 user_comment3 user_comment4
#

module Wintrgarden
  # >>> Language map list <<<
  LANGUAGE_MAP = {
    'Avar' => :ignore,
    'Farsi' => 'Persian',
    'Chinease' => 'Mandarin',
    'Somalia' => 'Somali',
    'Wolof' => :ignore,
    'Rwandi' => 'Kinyarwanda',
    'Slovenian' => 'Slovene',
    'Azerbaijani' => 'Azeri',
    'Twi' => 'Akan',
    'Aragonese' => :ignore,
    'Afar ' => :ignore,
    'Ganda' => :ignore,
    'Basque' => :ignore,
    'Tajik' => 'Tajiki Persion',
    'Kirghiz' => 'Kyrgyz',
    'Sanskrit' => :ignore,
    'Sardinian' => :ignore,
    'Shona' => :ignore,
    'Sichuan Yi' => :ignore,
    'Sinhalese' => :ignore,
    'Lingala' => :ignore,
    'Ewe' => :ignore,
    'Ossetian' => 'Ossetic',
    'Cambodian' => 'Khmer',
    'Norwegian Bokmål' => 'Norwegian',
    'Esperanto' => :ignore,
    'Moldovan' => 'Moldovan (Romanian)',
    'Kikuyu' => :ignore,
    'Northern Sami' => :ignore,
    'Galician' => :ignore,
    'Kongo' => :ignore,
    'Cree' => :ignore,
    'Uyghur' => :ignore,
    'Interlingua' => :ignore,
    'Sundanese' => :ignore,
    'Peul' => :ignore,
    'Haitian' => :ignore,
    'Herero' => :ignore,
    'Assamese' => :ignore,
    'Oromo' => :ignore,
    'Neapolitan' => :ignore,
  }.freeze
end

module Wintrgarden
  class UserMaster < BaseExporter
    TAG_COLUMNS = 4
    SKILL_COLUMNS = 10
    LANGUAGE_COLUMNS = 10
    OCCUPATION_COLUMNS = 10
    COMMENT_COLUMNS = 10

    MAX_COMMENT_LENGTH = 5000

    def initialize(users, root_occupations)
      @datums = users
      @root_occupations_map = root_occupations.map { |o| [o.id.to_s, o.translated_name(locale: :en)&.strip] }.to_h
      @user_exporter = Users.new
    end

    def header
      [
        *@user_exporter.header,
        'attachedPicture',
        'attachedCV',
        'otherDocs0',
        *Array.new(TAG_COLUMNS) { |i| "tag#{i}" },
        *Array.new(SKILL_COLUMNS) { |i| "skill#{i}" },
        # *Array.new(SKILL_COLUMNS) { |i| "skill_proficiency#{i}" },
        *Array.new(LANGUAGE_COLUMNS) { |i| "language#{i}" },
        *Array.new(LANGUAGE_COLUMNS) { |i| "language_proficiency#{i}" },
        *Array.new(OCCUPATION_COLUMNS) { |i| "businessArea#{i}" },
        # *Array.new(OCCUPATION_COLUMNS) { |i| "occupation_years_of_experience#{i}" },
        *Array.new(COMMENT_COLUMNS) { |i| "comment#{i}" },
      ]
    end

    def to_row(user)
      row = []

      # tags
      tags = Array.new(TAG_COLUMNS)
      user.tags.each_with_index do |tag, index|
        tags[index] = tag.name
      end

      # skills
      skills = Array.new(SKILL_COLUMNS)
      skills_proficiencies = Array.new(SKILL_COLUMNS)
      user.user_skills.each_with_index do |user_skill, index|
        skills[index] = user_skill.skill.translated_name(locale: :en)&.strip
        skills_proficiencies[index] = user_skill.proficiency_by_admin || user_skill.proficiency || -1
      end

      # languages
      languages = Array.new(LANGUAGE_COLUMNS)
      language_proficiencies = Array.new(LANGUAGE_COLUMNS)
      user.user_languages.each_with_index do |user_language, index|
        name = user_language.language.en_name&.strip
        next if LANGUAGE_MAP[name] == :ignore
        languages[index] = LANGUAGE_MAP.fetch(name, name)
        language_proficiencies[index] = user_language.proficiency_by_admin || user_language.proficiency || -1
      end

      # occupations
      occupations = Array.new(OCCUPATION_COLUMNS)
      occupation_yoes = Array.new(OCCUPATION_COLUMNS)
      user_occupations = user.user_occupations.map do |ou|
        occupation = ou.occupation
        [occupation.ancestry || occupation.id.to_s, ou.years_of_experience || -1]
      end

      if user_occupations.any?
        user_occupations.sort_by(&:last)
          .reverse
          .group_by(&:first)
          .map { |root_id, values| values.max_by(&:last) } # [root_id, years_of_experience]
          .map { |(root_id, yeo)| [@root_occupations_map.fetch(root_id), yeo] }
          .each_with_index do |(name, years_of_experience), index|
            occupations[index] = name
            occupation_yoes[index] = years_of_experience
          end
      end

      # images
      profile_image = nil
      if profile_record = user.user_images.profile.max_by(&:created_at)
        profile_image = profile_record.image_file_name
      end

      # cv
      cv_file = nil
      if cv_record = user.user_documents.cv.max_by(&:created_at)
        cv_file = cv_record.document_file_name
      end

      # personal_letter
      personal_letter_file = nil
      if personal_letter_record = user.user_documents.personal_letter.max_by(&:created_at)
        personal_letter_file = personal_letter_record.document_file_name
      end

      user_comments_columns = user_comments(user)

      [
        *@user_exporter.to_row(user),
        profile_image,
        cv_file,
        personal_letter_file,
        *tags.take(TAG_COLUMNS),
        *skills.take(SKILL_COLUMNS),
        # *skills_proficiencies.take(SKILL_COLUMNS),
        *languages.take(LANGUAGE_COLUMNS),
        *language_proficiencies.take(LANGUAGE_COLUMNS),
        *occupations.take(OCCUPATION_COLUMNS),
        # *occupation_yoes.take(OCCUPATION_COLUMNS),
        *user_comments_columns.take(COMMENT_COLUMNS),
        *row,
      ]
    end

    def user_comments(user)
      comments = Array.new(COMMENT_COLUMNS)

      # == employment periods ==
      employment_periods = user.employment_periods.includes(job: [:language, :translations])
      comments[0] = ">>> Employments (Anställningar) <<<\n" + employment_periods.map do |ep|
        <<~COMMENT
          Job: ##{ep.job&.id} #{ep.job&.original_name}
          Employer signed at: #{ep.employer_signed_at}
          Employee signed at: #{ep.employee_signed_at}
          Dates: #{ep.started_at}-#{ep.ended_at}
          Percentage: #{ep.percentage}
        COMMENT
      end.join("\n")

      # == job applications ==
      comments[1] = ">>> Job applications (Ansökningar) <<<\n" +
        user.job_users
          .includes(job: [:language, :translations])
          .map do |ju|
          <<~COMMENT
          ##{ju.job.id} #{ju.job.original_name}
          Status: #{ju.application_status}
          Applied at: #{ju.created_at}
          COMMENT
        end.join("\n")

      # == user fields ==
      comments[2] = [
        [">>> Description <<<", user.original_description],
        [">>> Job Experience <<<", user.original_job_experience],
        [">>> Education <<<", user.original_education],
        [">>> Competence <<<", user.original_competence_text],
      ].reject { |e| e.last.blank? }.join("\n\n")

      comments[3] = user.street

      comment_index = 4
      # == recruiter activity ==
      user.recruiter_activities.each do |ra|
        comments[comment_index] = <<~COMMENT
          >>> Recruiter Activity Log – #{ra.activity&.name || 'Övrigt'} <<<
          TYPE: #{ra.activity&.name || 'Övrigt'}
          BY: #{ra.author&.name || '-'}
          JOB: ##{ra.job&.id || '-'} #{ra.job&.name}

          #{ra.body}
        COMMENT
        comment_index += 1
      end

      comments.map do |comment|
        comment&.truncate(MAX_COMMENT_LENGTH, omission: '... (too long to fully import)')
      end
    end
  end
end
