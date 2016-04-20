# frozen_string_literal: true
require 'rails_helper'

RSpec.describe FrilansFinansApi::NilClient do
  client_methods = %i(currencies professions invoice create_user create_company create_invoice)

  client_methods.each do |client_method|
    describe "##{client_method}" do
      subject { described_class.new }

      it 'returns empty document' do
        response = subject.public_send(client_method)
        expect(response.body).to eq('{}')
      end
    end
  end
end
