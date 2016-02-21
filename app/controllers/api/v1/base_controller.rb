# frozen_string_literal: true
module Api
  module V1
    class BaseController < ::Api::BaseController
      resource_description do
        api_version '1.0'
        # rubocop:disable Metrics/LineLength
        app_info "
          # JustMatch API - v1.0 (alpha) [![JSON API 1.0](https://img.shields.io/badge/JSON%20API-1.0-lightgrey.svg)](http://jsonapi.org/)

          ---

          __Documentation about the current API.__

          The API follows the [JSON API 1.0](http://jsonapi.org) specification.

          ---

          ### Examples

          __Jobs__

          Get a list of available jobs

              #{Doxxer.curl_for(name: 'jobs')}

          Get a single job

              #{Doxxer.curl_for(name: 'jobs', id: 1)}

          __Skills__

          Get a list of skills

              #{Doxxer.curl_for(name: 'skills')}

          Get a single skill

              #{Doxxer.curl_for(name: 'skills', id: 1)}

          ### Authentication

          Pass the authorization token as a HTTP header

              #{Doxxer.curl_for(name: 'users', id: 1, with_auth: true, join_with: " \\
                     ")}
        "
        # rubocop:enable Metrics/LineLength
        api_base_url '/api/v1'
      end
    end
  end
end
