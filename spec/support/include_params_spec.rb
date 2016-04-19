# frozen_string_literal: true
require 'spec_helper'

RSpec.describe IncludeParams do
  describe '#permit' do
    describe 'many includes in param' do
      let(:param) { described_class.new('job-users,jobs') }

      it 'can return none' do
        expect(param.permit([])).to eq([])
        expect(param.permit('')).to eq([])
      end

      it 'can return one' do
        expect(param.permit(['job_users'])).to eq(['job_users'])
        expect(param.permit('job_users')).to eq(['job_users'])
      end

      it 'can return many' do
        expect(param.permit(%w(job_users jobs))).to eq(%w(job_users jobs))
        expect(param.permit('job_users', 'jobs')).to eq(%w(job_users jobs))
      end
    end

    describe 'one include in param' do
      let(:param) { described_class.new('users') }

      it 'can return none' do
        expect(param.permit([])).to eq([])
        expect(param.permit('')).to eq([])
        expect(param.permit('jobs')).to eq([])
      end

      it 'can return one' do
        expect(param.permit(['users'])).to eq(['users'])
        expect(param.permit('users')).to eq(['users'])
        expect(param.permit('users', 'jobs')).to eq(['users'])
      end
    end

    describe 'nested include in param' do
      let(:param) { described_class.new('users,users.images') }

      it 'can return none' do
        expect(param.permit([])).to eq([])
        expect(param.permit('')).to eq([])
        expect(param.permit('jobs')).to eq([])
      end

      it 'can return many' do
        expect(param.permit(['users'])).to eq(['users'])
        expect(param.permit('users', 'users.images')).to eq(['users', 'users.images'])
      end
    end

    describe 'nil param' do
      let(:nil_param) { described_class.new(nil) }

      it 'returns empty list' do
        expect(nil_param.permit('')).to eq([])
      end
    end
  end
end
