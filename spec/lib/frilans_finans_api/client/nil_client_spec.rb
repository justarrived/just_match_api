# frozen_string_literal: true
require 'rails_helper'

RSpec.describe FrilansFinansApi::NilClient do
  %i(
    currencies
    professions
    taxes
    invoice
    create_user
    create_company
    create_invoice
    update_invoice
    update_user
  ).each do |client_method|
    describe "##{client_method}" do
      subject { described_class.new }

      it 'returns empty document' do
        response = subject.public_send(client_method)
        expect(response.body).to eq('{}')
      end
    end
  end
end
