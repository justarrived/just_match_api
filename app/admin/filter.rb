# frozen_string_literal: true
ActiveAdmin.register Filter do
  menu parent: 'Filters'

  form do |f|
    f.inputs do
      f.input :name

      f.has_many :interest_filters, allow_destroy: false, new_record: true do |ff|
        ff.semantic_errors(*ff.object.errors.keys)

        ff.input :interest, as: :select, collection: Interest.with_translations
        ff.input :level, as: :select, collection: UserInterest::LEVEL_RANGE
        ff.input :level_by_admin, as: :select, collection: UserInterest::LEVEL_RANGE
      end

      f.has_many :skill_filters, allow_destroy: false, new_record: true do |ff|
        ff.semantic_errors(*ff.object.errors.keys)

        ff.input :skill, as: :select, collection: Skill.with_translations
        ff.input :proficiency, as: :select, collection: UserSkill::PROFICIENCY_RANGE
        ff.input :proficiency_by_admin, as: :select, collection: UserSkill::PROFICIENCY_RANGE # rubocop:disable Metrics/LineLength
      end

      f.has_many :language_filters, allow_destroy: false, new_record: true do |ff|
        ff.semantic_errors(*ff.object.errors.keys)

        ff.input :language, as: :select, collection: Language.order(:en_name)
        ff.input :proficiency, as: :select, collection: UserLanguage::PROFICIENCY_RANGE
        ff.input :proficiency_by_admin, as: :select, collection: UserLanguage::PROFICIENCY_RANGE # rubocop:disable Metrics/LineLength
      end
    end

    actions
  end

  permit_params do
    [:name]
  end

  controller do
    def scoped_collection
      super
    end

    def update_resource(filter, params_array)
      filter_params = params_array.first

      filter_interests_attrs = filter_params.delete(:filter_interests_attributes)
      interest_ids_param = (filter_interests_attrs || {}).map do |_index, attrs|
        {
          id: attrs[:interest_id],
          level: attrs[:level],
          level_by_admin: attrs[:level_by_admin]
        }
      end
      SetInterestFiltersService.call(
        filter: filter, interest_ids_param: interest_ids_param
      )

      filter_skills_attrs = filter_params.delete(:filter_skills_attributes)
      skill_ids_param = (filter_skills_attrs || {}).map do |_index, attrs|
        {
          id: attrs[:skill_id],
          proficiency: attrs[:proficiency],
          proficiency_by_admin: attrs[:proficiency_by_admin]
        }
      end
      SetSkillFiltersService.call(filter: filter, skill_ids_param: skill_ids_param)

      filter_languages_attrs = filter_params.delete(:filter_languages_attributes)
      language_ids_param = (filter_languages_attrs || {}).map do |_index, attrs|
        {
          id: attrs[:language_id],
          proficiency: attrs[:proficiency],
          proficiency_by_admin: attrs[:proficiency_by_admin]
        }
      end
      SetInterestFiltersService.call(
        filter: filter, language_ids_param: language_ids_param
      )
      super
    end

    # def find_resource
    #   Filter.includes(
    #     skill_filters: [:skill],
    #     language_filters: [:language],
    #     interest_filters: [:interest],
    #     languages: [:language],
    #     interests: [:translations, :language],
    #     skills: [:translations, :language]
    #   ).
    #     where(id: params[:id]).
    #     first!
    # end
  end
end
