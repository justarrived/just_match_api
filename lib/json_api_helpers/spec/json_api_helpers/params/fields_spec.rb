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

  describe '#permit' do
    context 'with fields params nil' do
      subject { described_class.new(nil) }

      it 'returns whitelist when nothing permitted' do
        expect(subject.permit(owner: [:email])).to eq(owner: ['email'])
      end
    end

    context 'with fields params' do
      subject { described_class.new(params) }

      let(:owner_params) { { owner: ['email'] } }
      let(:job_params) { { jobs: %w(full_name email) } }

      it 'returns empty when nothing permitted' do
        expect(subject.permit({})).to eq({})
      end

      it 'only returns allowed field' do
        expect(subject.permit(owner_params)).to eq(owner_params)
      end

      it 'only returns allowed fields' do
        expect(subject.permit(job_params)).to eq(job_params)
      end

      it 'only returns allowed fields' do
        both_params = job_params.merge(owner_params)
        expect(subject.permit(both_params)).to eq(both_params)
      end
    end
  end
end
