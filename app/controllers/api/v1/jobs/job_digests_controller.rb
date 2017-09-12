# frozen_string_literal: true

module Api
  module V1
    module Jobs
      class JobDigestsController < BaseController
        before_action :set_subscriber, only: %i(update destroy)
        before_action :set_job_digest, only: %i(update destroy)

        resource_description do
          api_versions '1.0'
          name 'JobDigest'
          short 'API for job digests'
          description ''
          formats [:json]
        end

        ALLOWED_INCLUDES = %w(address subscriber).freeze

        api :GET, '/jobs/:digest_subscriber_uuid_or_user_id/digests/', 'Get all job digest belonging to a certain subscriber' # rubocop:disable Metrics/LineLength
        description 'Returns a list of job digests if the user is allowed.'
        # ApipieDocHelper.params(self, Index::JobDigestsIndex)
        example Doxxer.read_example(JobDigest, plural: true)
        def index
          authorize(JobDigest)

          subscriber = Queries::FindDigestSubscriber.from_uuid_or_user_id(
            current_user: current_user,
            uuid_or_user_id: params[:digest_subscriber_id]
          )

          job_digests_index = Index::JobDigestsIndex.new(self)
          job_digests = job_digests_index.job_digests(subscriber.job_digests)

          api_render(job_digests, total: job_digests_index.count)
        end

        api :POST, '/jobs/digests/', 'Create job digest'
        description 'Create job digest.'
        error code: 400, desc: 'Bad request'
        error code: 422, desc: 'Unprocessable entity'
        ApipieDocHelper.params(self)
        param :data, Hash, desc: 'Top level key', required: true do
          param :attributes, Hash, desc: 'JobDigest attributes', required: true do
            # rubocop:disable Metrics/LineLength
            param :city, String, desc: 'City'
            param :notification_frequency, String, desc: "Notification frequency one of #{JobDigest::NOTIFICATION_FREQUENCY.keys.to_sentence}", required: true
            param :digest_subscriber_uuid, String, desc: 'Job digest subscriber UUID'
            param :occupation_ids, Array, of: Hash, desc: 'List of occupations' do
              param :id, Integer, desc: 'Occupation id', required: true
            end
            param :street1, String, desc: 'Street1 value'
            param :street2, String, desc: 'Street2 value'
            param :postal_code, String, desc: 'Postal_code value'
            param :municipality, String, desc: 'Municipality value'
            param :city, String, desc: 'City value'
            param :state, String, desc: 'State value'
            param :country_code, String, desc: 'Country_code value'
            param :latitude, Float, desc: 'Latitude value'
            param :longitude, Float, desc: 'Longitude value'
            param :user_id, String, desc: 'User id (required if email is blank)'
            param :email, String, desc: 'Email (required if email is blank)'
            # rubocop:enable Metrics/LineLength
          end
        end
        def create
          authorize(JobDigest)

          job_digest = CreateJobDigestService.call(
            job_digest_params: job_digest_params,
            address_params: address_params,
            occupation_ids_param: occupation_ids_param,
            current_user: current_user,
            uuid: jsonapi_params[:digest_subscriber_uuid].presence,
            user_id: jsonapi_params[:user_id].presence,
            email: jsonapi_params[:email].presence
          )

          if job_digest.persisted?
            api_render(job_digest, status: :created)
          else
            api_render_errors(job_digest)
          end
        end

        api :PATCH, '/jobs/subscribers/:digest_subscriber_uuid_or_user_id/digests/:job_digest_id', 'Update job digest' # rubocop:disable Metrics/LineLength
        description 'Update job digest.'
        error code: 400, desc: 'Bad request'
        error code: 404, desc: 'Not found'
        error code: 422, desc: 'Unprocessable entity'
        ApipieDocHelper.params(self)
        param :data, Hash, desc: 'Top level key', required: true do
          param :attributes, Hash, desc: 'JobDigest attributes', required: true do
            # rubocop:disable Metrics/LineLength
            param :digest_subscriber_uuid, String, desc: 'Job digest subscriber UUID'
            param :city, String, desc: 'City'
            param :notification_frequency, String, desc: "Notification frequency one of #{JobDigest::NOTIFICATION_FREQUENCY.keys.to_sentence}", required: true
            param :occupation_ids, Array, of: Hash, desc: 'List of occupations' do
              param :id, Integer, desc: 'Occupation id', required: true
            end
            param :street1, String, desc: 'Street1 value'
            param :street2, String, desc: 'Street2 value'
            param :postal_code, String, desc: 'Postal_code value'
            param :municipality, String, desc: 'Municipality value'
            param :city, String, desc: 'City value'
            param :state, String, desc: 'State value'
            param :country_code, String, desc: 'Country_code value'
            param :latitude, Float, desc: 'Latitude value'
            param :longitude, Float, desc: 'Longitude value'
            # rubocop:enable Metrics/LineLength
          end
        end
        def update
          authorize(@job_digest)

          @job_digest.assign_attributes(job_digest_params)
          @job_digest.deleted_at = nil

          if @job_digest.save
            @job_digest.address ||= Address.new
            @job_digest.address.update(address_params)

            @job_digest.occupations = Occupation.where(id: occupation_ids_param)

            api_render(@job_digest)
          else
            api_render_errors(@job_digest)
          end
        end

        api :DELETE, '/jobs/subscribers/:digest_subscriber_uuid_or_user_id/digests/:job_digest_id', 'Delete job digest' # rubocop:disable Metrics/LineLength
        description 'Delete digest subscriber.'
        error code: 400, desc: 'Bad request'
        error code: 404, desc: 'Not found'
        param :data, Hash, desc: 'Top level key', required: true do
          param :attributes, Hash, desc: 'JobDigest attributes', required: true do
            param :digest_subscriber_uuid, String, desc: 'Job digest subscriber UUID', required: true # rubocop:disable Metrics/LineLength
          end
        end
        ApipieDocHelper.params(self)
        def destroy
          authorize(@job_digest)

          @job_digest.soft_destroy!

          head :no_content
        end

        # rubocop:disable Metrics/LineLength
        api :GET, '/jobs/digests/notification-frequencies', 'Show all possible notification frequencies'
        description 'Returns a list of all possible notification frequencies.'
        example JSON.pretty_generate(JobDigestNotificationFrequenciesSerializer.serializable_resource.to_h)
        # rubocop:enable Metrics/LineLength
        def notification_frequencies
          authorize(JobDigest)

          render json: JobDigestNotificationFrequenciesSerializer.serializable_resource
        end

        private

        def set_subscriber
          @subscriber = DigestSubscriber.find_by!(uuid: params[:digest_subscriber_id])
        end

        def set_job_digest
          @job_digest = @subscriber.
                        job_digests.
                        find(params[:job_digest_id])
        end

        def occupation_ids_param
          (jsonapi_params[:occupation_ids] || []).map { |data| data[:id] }
        end

        def job_digest_params
          jsonapi_params.permit(:notification_frequency)
        end

        def address_params
          attributes = Address::PARTS + %i(latitude longitude)
          jsonapi_params.permit(*attributes)
        end
      end
    end
  end
end
