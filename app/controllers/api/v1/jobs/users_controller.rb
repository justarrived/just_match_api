# frozen_string_literal: true

module Api
  module V1
    module Jobs
      class UsersController < BaseController
        before_action :require_user
        before_action :set_job
        before_action :set_user

        after_action :verify_authorized, except: %i(missing_traits job_user)

        resource_description do
          resource_id 'jobs'
        end

        api :GET, '/jobs/:job_id/users/:user_id/missing-traits', 'Show missing user traits' # rubocop:disable Metrics/LineLength
        description 'Returns list of missing user traits.'
        error code: 401, desc: 'Unauthorized'
        error code: 404, desc: 'Not found'
        example JSON.pretty_generate(
          MissingUserTraitsSerializer.serialize(
            user_attributes: %i(street city zip),
            languages: [Struct.new(:id).new(1)],
            languages_hint: 'any skill hint',
            skills: [Struct.new(:id).new(1)],
            skills_hint: 'any skill hint'
          ).to_h
        )
        def missing_traits
          missing = Queries::MissingUserTraits
          missing_skills = missing.skills(user: @user, skills: @job.skills)
          missing_languages = missing.languages(user: @user, languages: @job.languages)
          missing_user_attributes = missing.attributes(
            user: @user,
            attributes: %i(ssn street zip city phone)
          )

          response = MissingUserTraitsSerializer.serialize(
            user_attributes: missing_user_attributes,
            skills: missing_skills,
            skills_hint: I18n.t('user.missing_job_skills_trait'),
            languages: missing_languages,
            languages_hint: I18n.t('user.missing_job_languages_trait')
          )
          render json: response
        end

        api :GET, '/jobs/:job_id/users/:user_id/job-user', 'Show job user'
        description 'Return a job user if one exist for the combination job <> user.'
        error code: 401, desc: 'Unauthorized'
        error code: 404, desc: 'Not found'
        example <<-JSON_EXAMPLE
        # This resource will always return a meta-key `has_applied`
        {
          "meta": {
            "has_applied": false
          }
        }
        JSON_EXAMPLE
        example Doxxer.read_example(JobUser)
        def job_user
          @job_user = JobUser.find_by(user: @user, job: @job)

          if @job_user
            api_render(@job_user, meta: { has_applied: true })
          else
            render json: { meta: { has_applied: false } }
          end
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
