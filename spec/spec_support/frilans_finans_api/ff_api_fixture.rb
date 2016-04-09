# frozen_string_literal: true

module FFApiFixture
  def self.read(type)
    File.read("spec/spec_support/frilans_finans_api/fixtures/#{type}_fixture.json")
  end
end
