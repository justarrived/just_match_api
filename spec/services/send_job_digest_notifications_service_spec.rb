# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendJobDigestNotificationsService do
  context 'matcher' do
    subject { described_class::JobDigestMatch }

    describe '#match?' do
      it 'returns true if matches' do
        job = FactoryGirl.build_stubbed(:job)
        job_digest = FactoryGirl.build_stubbed(:job_digest, city: nil)
        expect(subject.new(job, job_digest).match?).to eq(true)
      end

      it 'returns false if it does not match' do
        job = FactoryGirl.build_stubbed(:job)
        job_digest = FactoryGirl.build_stubbed(:job_digest, city: 'bad city')
        expect(subject.new(job, job_digest).match?).to eq(false)
      end
    end

    describe '#city?' do
      [nil, '   ', ' '].each do |city|
        it "returns true if job digest city is blank for #{city})" do
          job = FactoryGirl.build_stubbed(:job)
          job_digest = FactoryGirl.build_stubbed(:job_digest, city: city)
          expect(subject.new(job, job_digest).city?).to eq(true)
        end
      end

      it 'returns true if job digest city is within distance from job' do
        job = FactoryGirl.build_stubbed(:job, city: 'Stockholm')
        job_digest = FactoryGirl.build_stubbed(:job_digest, city: 'Stockholm')

        expect(subject.new(job, job_digest).city?).to eq(true)
      end

      it 'returns false if job digest city is within distance from job' do
        job = FactoryGirl.build_stubbed(:job, city: 'Göteborg')
        job_digest = FactoryGirl.build_stubbed(:job_digest, city: 'Stockholm')

        expect(subject.new(job, job_digest).city?).to eq(false)
      end
    end

    describe '#occupations?' do
      it 'returns true if any job digest occupations is empty' do
        job = FactoryGirl.build_stubbed(:job)
        job_digest = FactoryGirl.build_stubbed(:job_digest)
        expect(subject.new(job, job_digest).occupations?).to eq(true)
      end

      it 'returns false if any job occupations is empty and job digests is not' do
        first = FactoryGirl.build_stubbed(:occupation)

        job = FactoryGirl.build_stubbed(:job)
        job_digest = FactoryGirl.build_stubbed(:job_digest, occupations: [first])
        expect(subject.new(job, job_digest).occupations?).to eq(false)
      end

      it 'returns true if any job occupations is in job digest' do
        first = FactoryGirl.build_stubbed(:occupation)
        second = FactoryGirl.build_stubbed(:occupation)

        job = FactoryGirl.build_stubbed(:job, occupations: [first])
        job_digest = FactoryGirl.build_stubbed(:job_digest, occupations: [first, second])
        expect(subject.new(job, job_digest).occupations?).to eq(true)
      end
    end
  end
end
