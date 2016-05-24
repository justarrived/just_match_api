# frozen_string_literal: true
module FrilansFinansApi
  class FixtureClient
    # NOTE: If this is extracted out of just_match_api, this will need to change
    BASE_PATH = 'lib/frilans_finans_api/lib/frilans_finans_api/fixtures'

    Response = Struct.new(:body)

    def currencies(**_args)
      Response.new(read(:currencies))
    end

    def professions(**_args)
      Response.new(read(:professions))
    end

    def taxes(**_args)
      Response.new(read(:taxes))
    end

    def user(**_args)
      Response.new(read(:user))
    end

    def invoice(**_args)
      Response.new(read(:invoice))
    end

    def create_user(**_args)
      Response.new(read(:user))
    end

    def create_company(**_args)
      Response.new(read(:company))
    end

    def create_invoice(**_args)
      Response.new(read(:invoice))
    end

    def update_invoice(**_args)
      Response.new(read(:invoice))
    end

    def update_user(**_args)
      Response.new(read(:user))
    end

    def read(type)
      File.read("#{BASE_PATH}/#{type}_fixture.json")
    end
  end
end
