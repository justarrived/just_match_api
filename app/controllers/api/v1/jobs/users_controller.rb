# frozen_string_literal: true

module Api
  module V1
    module Jobs
      class UsersController < BaseController
        before_action :set_job
        before_action :set_user

        after_action :verify_authorized, except: %i(missing_traits)

        api :GET, '/jobs/:job_id/users/:user_id/missing-traits', 'Show missing user traits' # rubocop:disable Metrics/LineLength
        description 'Returns list of missing user traits.'
        error code: 404, desc: 'Not found'
        def missing_traits
          trait_queries = Queries::UserTraitsForJob
          missing_skills = trait_queries.missing_skills(job: @job, user: @user)
          missing_languages = trait_queries.missing_languages(job: @job, user: @user)
          missing_user_attributes = trait_queries.missing_user_attributes(user: @user)

          attributes = {}
          missing_user_attributes.each { |name| attributes[name] = {} }
          if missing_skills.any?
            attributes[:skill_ids] = { ids: missing_skills.map(&:id) }
          end
          if missing_languages.any?
            attributes[:language_ids] = { ids: missing_languages.map(&:id) }
          end

          response = JsonApiData.new(
            id: SecureGenerator.token(length: 32),
            type: :missing_user_traits,
            attributes: attributes,
            key_transform: key_transform_header
          )
          render json: response
        end

        private

        def set_job
          @job = policy_scope(Job).find(params[:job_id])
        end

        def set_user
          @user = User.scope_for(current_user).find(params[:user_id])
        end

        def pundit_user
          RatingPolicy::Context.new(current_user, @job)
        end
      end
    end
  end
end
