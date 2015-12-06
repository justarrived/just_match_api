class Api::V1::BaseController < Api::BaseController
  resource_description do
    api_version '1.0'
    app_info '
      Version 1.0 of the Just Arrived API.
      Here you can find all the documentation about the current API.
    '
    api_base_url '/api/v1'
  end
end
