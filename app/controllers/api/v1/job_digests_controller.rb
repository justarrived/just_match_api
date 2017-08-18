# frozen_string_literal: true

module Api
  module V1
    class JobDigestsController < BaseController
      after_action :verify_authorized, only: []

      resource_description do
        api_versions '1.0'
        name 'JobDigest'
        short 'API for job digests'
        description ''
        formats [:json]
      end

      api :POST, '/job-digests/', 'Create job digest'
      description 'Create job digest.'
      error code: 400, desc: 'Bad request'
      error code: 422, desc: 'Unprocessable entity'
      ApipieDocHelper.params(self)
      param :data, Hash, desc: 'Top level key', required: true do
        param :attributes, Hash, desc: 'JobDigest attributes', required: true do
          # rubocop:disable Metrics/LineLength
          param :city, String, desc: 'City'
          param :notification_frequency, String, desc: "Notification frequency one of #{JobDigest::NOTIFICATION_FREQUENCY.keys.to_sentence}", required: true
          param :occupation_ids, Array, of: Hash, desc: 'List of occupations' do
            param :id, Integer, desc: 'Occupation id', required: true
          end
          # rubocop:enable Metrics/LineLength
        end
      end
      def create
        job_digest = JobDigest.new(job_digest_params)

        if job_digest.save
          job_digest.occupations = Occupation.where(id: occupation_ids_param)

          api_render(job_digest, status: :created)
        else
          api_render_errors(job_digest)
        end
      end

      api :POST, '/job-digests/:job_digest_id', 'Update job digest'
      description 'Update job digest.'
      error code: 400, desc: 'Bad request'
      error code: 422, desc: 'Unprocessable entity'
      ApipieDocHelper.params(self)
      param :data, Hash, desc: 'Top level key', required: true do
        param :attributes, Hash, desc: 'JobDigest attributes', required: true do
          # rubocop:disable Metrics/LineLength
          param :city, String, desc: 'City'
          param :notification_frequency, String, desc: "Notification frequency one of #{JobDigest::NOTIFICATION_FREQUENCY.keys.to_sentence}", required: true
          param :occupation_ids, Array, of: Hash, desc: 'List of occupations' do
            param :id, Integer, desc: 'Occupation id', required: true
          end
          # rubocop:enable Metrics/LineLength
        end
      end
      def update
        job_digest = JobDigest.find(params[:job_digest_id])

        if job_digest.update(job_digest_params)
          job_digest.occupations = Occupation.where(id: occupation_ids_param)

          api_render(job_digest)
        else
          api_render_errors(job_digest)
        end
      end

      private

      def occupation_ids_param
        (jsonapi_params[:occupation_ids] || []).map { |data| data[:id] }
      end

      def job_digest_params
        jsonapi_params.permit(:city, :notification_frequency)
      end
    end
  end
end
