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

        api :GET, '/jobs/:job_digest_subscriber_uuid_or_user_id/digests/', 'Get all job digest belonging to a certain subscriber' # rubocop:disable Metrics/LineLength
        description 'Returns a list of job digests if the user is allowed.'
        # ApipieDocHelper.params(self, Index::JobDigestsIndex)
        example Doxxer.read_example(JobDigest, plural: true)
        def index
          authorize(JobDigest)

          subscriber = Queries::FindJobDigestSubscriber.from_uuid_or_user_id(
            current_user: current_user,
            uuid_or_user_id: params[:job_digest_subscriber_id]
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
            param :job_digest_subscriber_uuid, String, desc: 'Job digest subscriber UUID'
            param :occupation_ids, Array, of: Hash, desc: 'List of occupations' do
              param :id, Integer, desc: 'Occupation id', required: true
            end
            # rubocop:enable Metrics/LineLength
          end
        end
        def create
          authorize(JobDigest)

          job_digest = JobDigest.new(job_digest_params)
          uuid = jsonapi_params[:job_digest_subscriber_uuid]
          job_digest.subscriber = JobDigestSubscriber.find_by(uuid: uuid)
          job_digest.address = Address.new(address_params) unless address_params.empty?

          if job_digest.save
            job_digest.occupations = Occupation.where(id: occupation_ids_param)

            api_render(job_digest, status: :created)
          else
            api_render_errors(job_digest)
          end
        end

        api :PATCH, '/jobs/digests/:job_digest_id', 'Update job digest'
        description 'Update job digest.'
        error code: 400, desc: 'Bad request'
        error code: 404, desc: 'Not found'
        error code: 422, desc: 'Unprocessable entity'
        ApipieDocHelper.params(self)
        param :data, Hash, desc: 'Top level key', required: true do
          param :attributes, Hash, desc: 'JobDigest attributes', required: true do
            # rubocop:disable Metrics/LineLength
            param :job_digest_subscriber_uuid, String, desc: 'Job digest subscriber UUID'
            param :city, String, desc: 'City'
            param :notification_frequency, String, desc: "Notification frequency one of #{JobDigest::NOTIFICATION_FREQUENCY.keys.to_sentence}", required: true
            param :occupation_ids, Array, of: Hash, desc: 'List of occupations' do
              param :id, Integer, desc: 'Occupation id', required: true
            end
            # rubocop:enable Metrics/LineLength
          end
        end
        def update
          authorize(@job_digest)

          @job_digest.assign_attributes(job_digest_params)

          if @job_digest.save
            @job_digest.address ||= Address.new
            @job_digest.address.update(address_params)

            @job_digest.occupations = Occupation.where(id: occupation_ids_param)

            api_render(@job_digest)
          else
            api_render_errors(@job_digest)
          end
        end

        api :DELETE, '/jobs/digests/:job_digest_id', 'Delete job digest'
        description 'Delete job digest subscriber.'
        error code: 400, desc: 'Bad request'
        error code: 404, desc: 'Not found'
        ApipieDocHelper.params(self)
        def destroy
          authorize(@job_digest)

          @job_digest.destroy!

          head :no_content
        end

        private

        def set_subscriber
          uuid = jsonapi_params[:job_digest_subscriber_uuid]
          @subscriber = JobDigestSubscriber.find_by!(uuid: uuid)
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
          attributes = Address::PARTS + %i(longitude latitude)
          jsonapi_params.permit(*attributes)
        end
      end
    end
  end
end
