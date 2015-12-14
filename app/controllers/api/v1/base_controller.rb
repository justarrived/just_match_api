class Api::V1::BaseController < Api::BaseController
  resource_description do
    api_version '1.0'
    app_info "
      # JustArrived API (alpha) - _Version 1.0_

      ---

      Here you can find all the documentation about the current API.


      ### Examples

      To try the examples below simply copy-and-paste the cURL command below into your terminal and run it.

      __Jobs__

      Get a list of available jobs

      `#{Doxxer.curl_for(name: 'jobs')}`

      Get a single job

      `#{Doxxer.curl_for(name: 'jobs', id: 1)}`

      __Skills__

      Get a list of skills

      `#{Doxxer.curl_for(name: 'skills')}`

      Get a single skill

      `#{Doxxer.curl_for(name: 'skills', id: 1)}`
    "
     api_base_url '/api/v1'
  end
end
