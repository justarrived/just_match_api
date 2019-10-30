require 'wintrgarden_exporter/occupations'
require 'wintrgarden_exporter/skills'
require 'wintrgarden_exporter/tags'
require 'wintrgarden_exporter/user_comments'
require 'wintrgarden_exporter/user_documents'
require 'wintrgarden_exporter/user_images'
require 'wintrgarden_exporter/user_languages'
require 'wintrgarden_exporter/user_master'
require 'wintrgarden_exporter/user_occupations'
require 'wintrgarden_exporter/user_skills'
require 'wintrgarden_exporter/user_tags'
require 'wintrgarden_exporter/users'

module Wintrgarden
  class ExportRunner
    def self.perform(limit = 200_000)
      # Wintrgarden::Occupations.new(Occupation.with_translations.all).to_csv
      # Wintrgarden::Skills.new(Skill.with_translations.all).to_csv
      # Wintrgarden::Tags.new(Tag.all).to_csv
      # # Wintrgarden::UserComments.new(Tag.all).to_csv # TODO
      # Wintrgarden::UserLanguages.new(UserLanguage.includes(:language).all).to_csv
      # Wintrgarden::UserOccupations.new(UserOccupation.includes(occupation: [:language, :translations]).all).to_csv
      # Wintrgarden::UserSkills.new(UserSkill.all).to_csv
      # Wintrgarden::UserTags.new(UserTag.all).to_csv
      # Wintrgarden::Users.new(users_scope).to_csv

      Wintrgarden::UserDocuments.new(UserDocument.includes(:document).all).to_csv
      Wintrgarden::UserImages.new(UserImage.all).to_csv
      root_occupations = Occupation.where(ancestry: nil)
      Wintrgarden::UserMaster.new(users_scope(limit), root_occupations).to_csv
    end

    def self.users_scope(limit)
      User.with_translations
          .regular_users
          .includes(
            user_tags: [:tag],
            user_languages: [:language],
            user_occupations: [{ occupation: [:language, :translations] }],
            user_skills: [{ skill: [:language, :translations] }],
          )
          .where(admin: false, managed: false, anonymized_at: nil)
          .where('email NOT LIKE :prefix', prefix: 'ghost+%')
          .where('email NOT LIKE :prefix', prefix: '%justarrived.se')
          .limit(limit)
    end
  end
end
