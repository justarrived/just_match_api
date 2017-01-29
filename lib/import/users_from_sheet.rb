# frozen_string_literal: true
module Import
  class UsersFromSheet
    def self.call(path = 'tmp/validation-mapping.csv')
      csv_string = File.read(path)
      csv = HoneyFormat::CSV.new(csv_string)

      csv.rows.each { |user| process_user(user) }
    end

    def self.process_user(data)
      user_id = data.user_id&.strip
      email = data.email&.strip&.downcase
      # Don't bother if we can't identify the user
      return if (user_id.nil? || user_id.empty?) && (email.nil? || email.empty?)

      en_language = Language.find_by(lang_code: :en)

      user = find_or_initialize_user(data)
      user.assign_attributes(user_attributes(data))
      user.language = en_language if user.language.nil?
      user.password = SecureGenerator.token(length: 40) unless user.persisted?
      user.save

      fail "User must be persisted! #{user_id}" if user.errors.any?

      process_foi(user, data)
      process_user_languages(user, data)
      process_skills(user, data)
    end

    def self.find_or_initialize_user(data)
      User.find_by(id: data.user_id) ||
        User.find_by(email: data.email.strip.downcase) ||
        User.new
    end

    def self.user_attributes(data)
      name_parts = data.name.split(' ')

      {
        first_name: name_parts.shift,
        last_name: name_parts.join(' '),
        email: data.email.strip.downcase,
        current_status: current_status(data.current_status),
        interview_comment: data.interview_comment,
        arbetsformedlingen_registered_at: data.arbetsformedlingen_registered_at,
        interviewed_at: data.interview_date,
        interviewed_by_user_id: find_interview_user_id(data.interviewed_by)
      }
    end

    def self.process_user_languages(user, data)
      {
        swedish: :sv,
        english: :en,
        arabic: :ar,
        tigrinya: :ti,
        dari: :fa_AF,
        pashto: :ps,
        french: :fr,
        german: :de,
        spanish: :es
      }.each do |column_name, lang_code|
        language = Language.find_by(lang_code: lang_code)
        value = data.public_send(column_name)&.strip
        next if value.nil? || value.empty?

        user_language = UserLanguage.find_or_initialize_by(user: user, language: language)
        user_language.proficiency_by_admin = value
        user_language.save
      end
    end

    def self.process_foi(user, data)
      en_language = Language.find_by(lang_code: :en)
      [
        :foi_general_maintenance,
        :foi_construction,
        :foi_administration,
        :foi_cleaning,
        :foi_restaurant_or_kitchen,
        :foi_customer_service
      ].each do |column_name|
        value = data.public_send(column_name)&.strip
        next if value.nil? || value.empty?

        interest_name = format_interest_name(column_name)
        interest = InterestTranslation.find_by(name: interest_name)&.interest
        if interest.nil?
          interest = Interest.create(name: interest_name, language: en_language)
          interest.set_translation(name: interest_name)
        end

        user_interest = UserInterest.find_or_initialize_by(user: user, interest: interest)
        user_interest.level_by_admin = value
        user_interest.save
      end
    end

    def self.process_skills(user, data)
      en_language = Language.find_by(lang_code: :en)
      [
        :swedish_driving_license,
        :social_skills,
        :flexibility,
        :ambition,
        :attitude,
        :independent,
        :economy,
        :translation,
        :it
      ].each do |column_name|
        value = data.public_send(column_name)&.strip
        next if value.nil? || value.empty?

        skill_name = format_skill_name(column_name)
        skill = SkillTranslation.find_by(name: skill_name)&.skill
        if skill.nil?
          skill = Skill.create(name: skill_name, language: en_language)
          skill.set_translation(name: skill_name)
        end

        user_skill = UserSkill.find_or_initialize_by(user: user, skill: skill)
        user_skill.proficiency_by_admin = value
        user_skill.save
      end
    end

    def self.current_status(status)
      return :permanent_residence if status == 'Har uppehållstillstånd/svensk medborgare'
      return :asylum_seeker if status == 'Asylsökande eller EU-medborgare'

      nil
    end

    def self.find_interview_user_id(interviewed_by)
      return 42 if interviewed_by == 'Yazan'
      return 104 if interviewed_by == 'Lova'
      return 44 if interviewed_by == 'Anna'

      nil
    end

    def self.format_interest_name(name)
      {
        foi_general_maintenance: 'General maintenance',
        foi_construction: 'Construction',
        foi_administration: 'Administration',
        foi_cleaning: 'Cleaning',
        foi_restaurant_or_kitchen: 'Restaurant or kitchen',
        foi_customer_service: 'Customer service'
      }.fetch(name, nil)
    end

    def self.format_skill_name(name)
      {
        swedish_driving_license: 'Swedish driving license',
        social_skills: 'Social skills',
        flexibility: 'Flexibility',
        ambition: 'Ambition',
        attitude: 'Attitude',
        independent: 'Independent',
        economy: 'Economy',
        translation: 'Translation',
        it: 'IT'
      }.fetch(name, nil)
    end
  end
end
