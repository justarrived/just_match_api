# frozen_string_literal: true
require 'uri'

module FrilansFinansApi
  class FixtureClient
    # NOTE: If this is extracted out of just_match_api, this will need to change
    BASE_PATH = __dir__ + '/../../../fixtures'

    HTTP_STATUS = 200
    FIXTURE_URI = URI('http://example.com')

    Request = Struct.new(:uri)
    Response = Struct.new(:code, :body, :request)

    def currencies(**_args)
      mock_response(read(:currencies))
    end

    def professions(**_args)
      mock_response(read(:professions))
    end

    def users(**_args)
      mock_response(read(:users))
    end

    def salaries(**_args)
      mock_response(read(:salaries))
    end

    def taxes(**_args)
      mock_response(read(:taxes))
    end

    def user(**_args)
      mock_response(read(:user))
    end

    def invoice(**_args)
      mock_response(read(:invoice))
    end

    def create_user(**_args)
      mock_response(read(:user))
    end

    def create_company(**_args)
      mock_response(read(:company))
    end

    def create_employment_certificate(**_args)
      mock_response('{}')
    end

    def create_invoice(**_args)
      mock_response(read(:invoice))
    end

    def update_invoice(**_args)
      mock_response(read(:invoice))
    end

    def update_user(**_args)
      mock_response(read(:user))
    end

    def read(type)
      File.read("#{BASE_PATH}/#{type}_fixture.json")
    end

    private

    def mock_response(body)
      request = Request.new(FIXTURE_URI)
      Response.new(HTTP_STATUS, body, request)
    end
  end
end
