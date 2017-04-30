# frozen_string_literal: true

module Api
  module V1
    module PartnerFeeds
      class JobsController < BaseController
        before_action :verify_linkedin_sync_key
        after_action :verify_authorized, except: [:linkedin]

        resource_description do
          resource_id 'PartnerFeeds'
          short 'API for partner job feeds'
          name 'Partner Feeds'
          description 'Job feeds for partners'
          formats [:json, :xml]
          api_versions '1.0'
        end

        api :GET, '/partner-feeds/jobs/linkedin', 'List jobs for LinkedIN feed'
        description 'Returns a list of jobs for LinkedIN to consume.'
        param :auth_token, String, desc: 'Auth token', required: true
        example <<-JSON_EXAMPLE
        [
          {
            "company": {
              "name": "Macejkovic, Lynch and Considine",
              "id": "8874830584",
              "country_code": "SE",
              "postal_code": "19149"
            },
            "job": {
              "title": "Watman",
              "description": "Something something, darkside.",
              "location": "Storta Nygatan 36, 21137, Stockholm, Sverige",
              "country_code": "SE",
              "postal_code": "21137",
              "application_url": "https://app.justarrived.se/job/300"
            }
          },
          {
             "...": "..."
          }
        ]
        JSON_EXAMPLE
        example <<-XML_EXAMPLE
        <?xml version="1.0" encoding="UTF-8"?>
        <objects type="array">
            <object>
                <company>
                    <name>Macejkovic, Lynch and Considine</name>
                    <id>8874830584</id>
                    <country-code>SE</country-code>
                    <postal-code>19149</postal-code>
                </company>
                <job>
                    <title>Watman</title>
                    <description>Something something, darkside.</description>
                    <location>Storta Nygatan 36, 21137, Stockholm, Sverige</location>
                    <country-code>SE</country-code>
                    <postal-code>21137</postal-code>
                    <application-url>https://app.justarrived.se/job/300</application-url>
                </job>
            </object>
            <object>
              ....
            </object>
        </objects>
        XML_EXAMPLE
        def linkedin
          jobs = Job.with_translations.
                 includes(:company).
                 order(created_at: :desc).
                 limit(AppConfig.linkedin_job_records_feed_limit)

          attributes = LinkedinJobsSerializer.attributes(jobs: jobs)

          if json_content_type?
            render json: attributes.as_json
          else
            render xml: attributes.to_xml
          end
        end

        private

        def verify_linkedin_sync_key
          unauthorized! if params[:auth_token].blank?
          return if AppSecrets.linkedin_sync_key == params[:auth_token]

          unauthorized!
        end

        def json_content_type?
          ['application/json', 'application/vnd.api+json'].include?(request.content_type)
        end

        def unauthorized!
          raise Pundit::NotAuthorizedError
        end
      end
    end
  end
end
