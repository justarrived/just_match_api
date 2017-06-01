# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Alternate FrilansFinansApi client' do
  [
    FrilansFinansApi::FixtureClient,
    FrilansFinansApi::NilClient
  ].each do |alternate_client_klass|
    context alternate_client_klass do
      it 'implements all client methods' do
        client_methods = FrilansFinansApi::Client.instance_methods
        alternate_client_methods = alternate_client_klass.instance_methods

        client_methods -= Object.instance_methods + [:request]
        alternate_client_methods -= Object.instance_methods

        client_methods.each do |client_method|
          expect(alternate_client_methods).to include(client_method)
        end
      end
    end
  end
end
