# frozen_string_literal: true

module Api
  module V1
    module Jobs
      class UsersController < BaseController
        before_action :require_user
        before_action :set_job
        before_action :set_user

        after_action :verify_authorized, except: %i(missing_traits job_user)

        api :GET, '/jobs/:job_id/users/:user_id/missing-traits', 'Show missing user traits' # rubocop:disable Metrics/LineLength
        description 'Returns list of missing user traits.'
        error code: 401, desc: 'Unauthorized'
        error code: 404, desc: 'Not found'
        example <<-JSON_EXAMPLE
        # Response example
        {
          "data": {
            "id": "c67f8be62d3d4e722a00cd68e5970c2a",
            "type": "missing_user_traits",
            "attributes": {
              "city": {},
              "skill-ids": {
                "ids": [1, 2],
                "hint": "please add the missing skills"
              },
              "language-ids": {
                "ids":[5, 6],
                "hint": "please add the missing languages"
              }
            }
          }
        }
        JSON_EXAMPLE
        def missing_traits
          trait_queries = Queries::UserTraitsForJob
          missing_skills = trait_queries.missing_skills(job: @job, user: @user)
          missing_languages = trait_queries.missing_languages(job: @job, user: @user)
          missing_user_attributes = trait_queries.missing_user_attributes(user: @user)

          response = MissingUserTraitsSerializer.serialize(
            user_attributes: missing_user_attributes,
            skills: missing_skills,
            languages: missing_languages,
            key_transform: key_transform_header
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
