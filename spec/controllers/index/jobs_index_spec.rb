# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Index::JobsIndex do
  # NOTE: #setup_jobs makes these tests horribly slow.. There is no doubt some coupling
  # here between the database and JobsIndex, we should try to fix that later on..
  let!(:setup_jobs) do
    [
      FactoryGirl.create(:job, users: [user, other_user]),
      FactoryGirl.create(:job, users: [other_user])
    ]
  end
  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }

  describe '#filter_job_user_jobs' do
    context 'returns job scope untouched' do
      it 'if no current_user' do
        index = described_class.new(nil)
        jobs = index.filter_job_user_jobs(Job, user.id.to_s)
        expect(jobs.count).to eq(setup_jobs.length)
      end

      it 'filter_user_id is blank' do
        index = described_class.new(nil)
        jobs = index.filter_job_user_jobs(Job, nil)
        expect(jobs.count).to eq(setup_jobs.length)
      end

      it 'for users that tries to filter/select jobs for someone elses user id' do
        index = described_class.new(nil, other_user)
        jobs = index.filter_job_user_jobs(Job, user.id.to_s)
        expect(jobs.count).to eq(setup_jobs.length)
      end
    end

    context 'returns filtered job scope' do
      it 'for users that filters their jobs' do
        index = described_class.new(nil, user)
        jobs = index.filter_job_user_jobs(Job, "-#{user.id}")

        expect(jobs.count).to eq(1)
      end

      it 'for users that selects their jobs' do
        index = described_class.new(nil, other_user)
        jobs = index.filter_job_user_jobs(Job, other_user.id.to_s)

        expect(jobs.count).to eq(2)
      end
    end
  end
end
