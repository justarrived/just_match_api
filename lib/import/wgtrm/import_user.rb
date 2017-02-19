# frozen_string_literal: true
module Wgtrm
  class ImportUser
    attr_reader :user, :wgtrm_user, :user_languages, :user_tags, :user_interests

    def self.commit(user, wgtrm_user)
      new(user, wgtrm_user).tap(&:commit)
    end

    def initialize(user, wgtrm_user)
      @user = user             || fail('User can *not* be nil')
      @wgtrm_user = wgtrm_user || fail('Wgtrm User can *not* be nil')

      @user_languages = nil
      @user_tags      = nil
      @user_interests = nil
    end

    def commit
      @update_user    ||= set_user_attributes
      @user_languages ||= set_user_languages
      @user_tags      ||= set_user_tags
      @user_interests ||= set_user_interests
      @default_langs  ||= conditionally_set_default_users_language
    end

    def set_user_attributes
      @user.first_name        ||= @wgtrm_user.first_name
      @user.last_name         ||= @wgtrm_user.last_name
      @user.language          ||= ::Language.find_by(lang_code: :en)
      @user.country_of_origin ||= @wgtrm_user.country_of_origin

      @user.save!
      @user
    end

    def set_user_languages
      @wgtrm_user.languages.map do |language_proficiency|
        language = ::Language.find_by(en_name: language_proficiency.name)
        if language.nil?
          Rails.logger.info "No lang found for #{language_proficiency.name}"
          next
        end
        ::UserLanguage.find_or_initialize_by(user: @user, language: language).tap do |ul|
          ul.proficiency ||= language_proficiency.proficiency
          ul.save!
        end
      end.reject(&:nil?)
    end

    def set_user_tags
      wgtrm_user.tags.map do |string|
        tag_string = string.strip
        tag = ::Tag.find_or_create_by(name: tag_string)
        ::UserTag.find_or_create_by(user: user, tag: tag).tap(&:validate)
      end.reject(&:nil?)
    end

    def set_user_interests
      @wgtrm_user.interests.map do |string|
        next if string.blank?

        interest_string = string.strip
        interest = ::InterestTranslation.find_by(name: interest_string)&.interest
        interest ||= ::Interest.new(name: interest_string).tap do |i|
          i.language = ::Language.find_by(lang_code: :en)
          i.save!
          i.set_translation(name: interest_string)
        end

        ::UserInterest.find_or_create_by(user: user, interest: interest).tap(&:validate)
      end.reject(&:nil?)
    end

    def conditionally_set_default_users_language
      return true if @user.created_at > 1.day.ago
      sys_langs = %w(en sv ar)
      lang = nil
      @user_languages.each do |ul|
        language = ul.language
        lang = language if ul.proficiency == 5 && sys_langs.include?(language.lang_code)
      end
      if lang
        @user.language = lang
        @user.save!
      end
      true
    end
  end
end
