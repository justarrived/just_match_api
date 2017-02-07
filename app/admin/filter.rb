# frozen_string_literal: true
ActiveAdmin.register Filter do
  menu parent: 'Filters'

  member_action :update_users, method: :post do
    filter = resource
    message = I18n.t('admin.filter_user.update_users_notice')
    SetFilterUsersJob.perform_now(filter: filter)
    # SetFilterUsersService.call(filter: filter)
    path = admin_filter_users_path + AdminHelpers::Link.query(:filter_id, filter.id) # rubocop:disable Metrics/LineLength
    redirect_to(path, notice: message)
  end

  action_item :view, only: :show do
    title = I18n.t('admin.filter_user.update_users_btn')
    path = update_users_admin_filter_path(resource)
    link_to title, path, method: :post
  end

  show do
    badge_name = lambda do |name, value, value_by_admin|
      simple_badge_tag("#{name} (#{value || '-'}/#{value_by_admin || '-'})")
    end

    attributes_table do
      row :id
      row :name
      row :updated_at { |filter| datetime_ago_in_words(filter.updated_at) }
      row :created_at { |filter| datetime_ago_in_words(filter.created_at) }
      row :skills do |filter|
        skill_filters = filter.skill_filters.includes(skill: [:language, :translations])
        badges = skill_filters.map do |sf|
          badge_name.call(sf.skill.name, sf.proficiency, sf.proficiency_by_admin)
        end
        safe_join(badges, '')
      end
      row :languages do |filter|
        badges = filter.language_filters.includes(:language).map do |lf|
          badge_name.call(lf.language.name, lf.proficiency, lf.proficiency_by_admin)
        end
        safe_join(badges, '')
      end
      row :interests do |filter|
        badges = filter.interest_filters.includes(:interest).map do |inf|
          badge_name.call(inf.interest.name, inf.level, inf.level_by_admin)
        end
        safe_join(badges, '')
      end

      row :matching_user_count do |filter|
        Queries::UserTraits.by_filter(filter).count
      end
    end

    active_admin_comments
  end

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
    [
      :name,
      skill_filters_attributes: [:skill_id, :proficiency, :proficiency_by_admin],
      language_filters_attributes: [:language_id, :proficiency, :proficiency_by_admin],
      interest_filters_attributes: [:interest_id, :level, :level_by_admin]
    ]
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
      SetLanguageFiltersService.call(
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
