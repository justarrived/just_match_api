# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendJobDigestNotificationsService do
  context 'matcher' do
    subject { described_class::JobDigestMatch }

    describe '#match?' do
      it 'returns true if matches' do
        job = FactoryBot.build_stubbed(:job)
        address = FactoryBot.build_stubbed(:address, city: nil)
        job_digest = FactoryBot.build_stubbed(:job_digest, addresses: [address])
        expect(subject.new(job, job_digest).match?).to eq(true)
      end

      it 'returns false if it does not match' do
        job = FactoryBot.build_stubbed(:job, longitude: nil, latitude: nil)
        address = FactoryBot.build_stubbed(:address, longitude: 13, latitude: 13)
        job_digest = FactoryBot.build_stubbed(:job_digest, addresses: [address])
        expect(subject.new(job, job_digest).match?).to eq(false)
      end
    end

    describe '#address?' do
      it 'returns true if job digest has no address' do
        job = FactoryBot.build_stubbed(:job)
        job_digest = FactoryBot.build_stubbed(:job_digest, addresses: [])

        matcher = subject.new(job, job_digest)

        expect(matcher.address?).to eq(true)
      end

      it 'returns true if job digest address has no coordinates' do
        address = FactoryBot.build_stubbed(
          :address,
          city: 'Stockholm',
          latitude: nil,
          longitude: nil
        )
        job = FactoryBot.build_stubbed(:job)
        job_digest = FactoryBot.build_stubbed(:job_digest, addresses: [address])

        matcher = subject.new(job, job_digest)

        expect(matcher.address?).to eq(true)
      end
    end

    describe '#within_distance?' do
      it 'returns true if job digest city is within distance from job' do
        job = FactoryBot.build_stubbed(
          :job,
          city: 'Stockholm',
          latitude: 59.32932,
          longitude: 18.06858
        )
        address = FactoryBot.build_stubbed(
          :address,
          city: 'Stockholm',
          latitude: 59.32932,
          longitude: 18.06858
        )
        job_digest = FactoryBot.build_stubbed(
          :job_digest,
          addresses: [address],
          max_distance: 50
        )

        expect(subject.new(job, job_digest).within_distance?(address)).to eq(true)
      end

      it 'returns false if job digest address is not within distance from job' do
        job = FactoryBot.build_stubbed(
          :job,
          city: 'Stockholm',
          latitude: 59.32932,
          longitude: 18.06858
        )
        address = FactoryBot.build_stubbed(
          :address,
          city: 'Lund',
          latitude: 55.6987817,
          longitude: 13.1975525
        )
        job_digest = FactoryBot.build_stubbed(
          :job_digest,
          addresses: [address],
          max_distance: 50
        )

        expect(subject.new(job, job_digest).within_distance?(address)).to eq(false)
      end

      it 'returns true if job digest address is within distance from job' do
        job = FactoryBot.build_stubbed(
          :job,
          city: 'Stockholm',
          latitude: 59.32932,
          longitude: 18.06858
        )
        address = FactoryBot.build_stubbed(
          :address,
          city: 'Lund',
          latitude: 55.6987817,
          longitude: 13.1975525
        )
        job_digest = FactoryBot.build_stubbed(
          :job_digest,
          addresses: [address],
          max_distance: 500
        )

        expect(subject.new(job, job_digest).within_distance?(address)).to eq(true)
      end

      it 'returns false if job digest address exists and job is not geocoded' do
        address = FactoryBot.build_stubbed(
          :address,
          city: 'Stockholm',
          latitude: 13,
          longitude: 13
        )
        job = FactoryBot.build_stubbed(:job)
        job_digest = FactoryBot.build_stubbed(:job_digest, addresses: [address])

        matcher = subject.new(job, job_digest)

        expect(matcher.address?).to eq(false)
      end
    end

    describe '#occupations?' do
      it 'returns true if any job digest occupations is empty' do
        job = FactoryBot.build_stubbed(:job)
        job_digest = FactoryBot.build_stubbed(:job_digest)
        expect(subject.new(job, job_digest).occupations?).to eq(true)
      end

      it 'returns false if any job occupations is empty and job digests is not' do
        first = FactoryBot.build_stubbed(:occupation)

        job = FactoryBot.build_stubbed(:job)
        job_digest = FactoryBot.build_stubbed(:job_digest, occupations: [first])
        expect(subject.new(job, job_digest).occupations?).to eq(false)
      end

      it 'returns true if any job occupations is in job digest' do
        first = FactoryBot.build_stubbed(:occupation)
        second = FactoryBot.build_stubbed(:occupation)

        job = FactoryBot.build_stubbed(:job, occupations: [first])
        job_digest = FactoryBot.build_stubbed(:job_digest, occupations: [first, second])
        expect(subject.new(job, job_digest).occupations?).to eq(true)
      end

      context 'with children occupations' do
        it 'returns true if any job occupations is in job digest' do
          first = FactoryBot.build_stubbed(:occupation)
          second = FactoryBot.build_stubbed(:occupation, parent: first)

          job = FactoryBot.build_stubbed(:job, occupations: [first])
          job_digest = FactoryBot.build_stubbed(:job_digest, occupations: [second])
          expect(subject.new(job, job_digest).occupations?).to eq(true)
        end
      end
    end

    describe '#occupation_root_ids' do
      it 'returns the ancestors id if present' do
        root_occupation = FactoryBot.build_stubbed(:occupation)
        middle_occupation = FactoryBot.build_stubbed(
          :occupation, ancestry: root_occupation.id.to_s
        )
        child_occupation = FactoryBot.build_stubbed(
          :occupation, ancestry: middle_occupation.id.to_s
        )
        occupations = [root_occupation, middle_occupation, child_occupation]

        matcher = subject.new(nil, nil)
        expected = [root_occupation.id.to_s, middle_occupation.id.to_s]

        expect(matcher.occupation_root_ids(occupations)).to match(expected)
      end
    end
  end
end
