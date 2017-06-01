# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JsonApiHelpers::Params::Fields do
  let(:params) do
    {
      jobs: 'id,full-name,email',
      owner: 'email'
    }
  end

  describe '#to_h' do
    it 'converts fields params to hash' do
      fields_params = {
        jobs: 'name,hours,job-date',
        users: 'name'
      }
      expected = {
        jobs: %w(name hours job_date),
        users: %w(name)
      }
      expect(described_class.new(fields_params).to_h).to eq(expected)
    end

    it 'returns empty hash when fields params empty' do
      expect(described_class.new({}).to_h).to eq({})
    end
  end
end
