# frozen_string_literal: true

module FrilansFinansApi
  class FixtureClient
    # NOTE: If this is extracted out of just_match_api, this will need to change
    BASE_PATH = 'lib/frilans_finans_api/lib/frilans_finans_api/fixtures'

    Response = Struct.new(:body)

    def professions(**_args)
      Response.new(read(:professions))
    end

    def create_user(**_args)
      Response.new(read(:user))
    end

    def create_company(**_args)
      Response.new(read(:company))
    end

    def read(type)
      File.read("#{BASE_PATH}/#{type}_fixture.json")
    end
  end
end
