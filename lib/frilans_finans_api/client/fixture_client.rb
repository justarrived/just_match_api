# frozen_string_literal: true

module FrilansFinansApi
  class FixtureClient
    Response = Struct.new(:body)

    def professions(**_args)
      Response.new(read(:professions))
    end

    def read(type)
      File.read("lib/frilans_finans_api/fixtures/#{type}_fixture.json")
    end
  end
end
