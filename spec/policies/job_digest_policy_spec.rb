# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobDigestPolicy do
  before(:each) do
    allow_any_instance_of(User).to receive(:persisted?).and_return(true)
  end

  let(:job_digest) { FactoryGirl.build_stubbed(:job_digest) }

  context 'user' do
    subject { described_class.new(nil, job_digest) }

    it 'returns true for index' do
      expect(subject.index?).to eq(true)
    end

    it 'returns true for create' do
      expect(subject.create?).to eq(true)
    end

    it 'returns true for update' do
      expect(subject.update?).to eq(true)
    end

    it 'returns true for destroy' do
      expect(subject.destroy?).to eq(true)
    end

    it 'only returns associated job digests in scope that are not deleted' do
      job_digest = FactoryGirl.create(:job_digest)
      FactoryGirl.create(:job_digest, deleted_at: 1.day.ago)
      expect(subject.scope).to eq([job_digest])
    end
  end
end
