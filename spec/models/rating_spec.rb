# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Rating, type: :model do
  let(:from_user) { FactoryGirl.build(:user) }
  let(:to_user) { FactoryGirl.build(:user) }
  let(:job) { FactoryGirl.build(:job) }

  subject do
    FactoryGirl.build(
      :rating,
      from_user: from_user,
      to_user: to_user,
      comment: comment,
      job: job
    )
  end

  let(:comment) { nil }

  describe '#validate_comment_owned_by' do
    context 'invalid' do
      let(:comment) { FactoryGirl.build(:comment, owner: to_user) }

      it 'adds error' do
        subject.validate

        err_msg = 'must be owned by the user making the rating'
        expect(subject.errors.messages[:comment]).to include(err_msg)
      end
    end

    context 'valid' do
      let(:comment) { FactoryGirl.build(:comment, owner: from_user) }

      it 'adds no error' do
        expect(subject.errors.messages[:comment]).to eq(nil)
      end
    end
  end

  describe '#validate_job_concluded' do
    let(:job) { FactoryGirl.create(:passed_job) }
    let(:rating) { FactoryGirl.build(:rating, job: job) }

    context 'valid' do
      it 'adds no error if there is *no* accepted job user' do
        rating.validate
        expect(rating.errors.messages[:job_user]).to eq(nil)
      end

      it 'adds no error if the job is concluded' do
        FactoryGirl.create(:job_user_concluded, job: job)
        rating.validate
        expect(rating.errors.messages[:job_user]).to eq(nil)
      end
    end

    context 'invalid' do
      it 'adds error' do
        FactoryGirl.create(:job_user_accepted, job: job)
        rating.validate
        expect(rating.errors.messages[:job_user]).to include('must be concluded')
      end
    end
  end

  describe 'user allowed to rate' do
    let(:user_subject) { from_user }
    subject { described_class.user_allowed_to_rate?(user: user_subject, job: job) }

    context 'invalid' do
      it 'returns false' do
        expect(subject).to eq(false)
      end

      it 'returns false if job is nil' do
        described_class.user_allowed_to_rate?(job: nil, user: user_subject)
      end

      it 'returns false if user is nil' do
        described_class.user_allowed_to_rate?(job: job, user: nil)
      end
    end

    context 'owner' do
      let(:job) { FactoryGirl.build(:job, owner: user_subject) }

      it 'returns true' do
        expect(subject).to eq(true)
      end
    end

    context 'accepted_applicant' do
      it 'returns true' do
        FactoryGirl.create(:job_user, job: job, user: user_subject)
        job.accept_applicant!(user_subject)

        expect(subject).to eq(true)
      end
    end
  end

  [:from_user, :to_user].each do |relation_name|
    describe "validate #{relation_name}" do
      let(:user_type_sym) { relation_name }
      let(:user_subject) { public_send(user_type_sym) }

      context 'invalid' do
        it 'adds error' do
          subject.validate

          err_msg = 'must be job owner or the accepted applicant'
          expect(subject.errors.messages[user_type_sym]).to include(err_msg)
        end
      end

      context 'owner' do
        let(:job) { FactoryGirl.build(:job, owner: user_subject) }

        it 'adds no error' do
          subject.validate

          expect(subject.errors.messages[user_type_sym]).to be_nil
        end
      end

      context 'accepted_applicant' do
        it 'adds no error' do
          FactoryGirl.create(:job_user, job: job, user: user_subject)
          job.accept_applicant!(user_subject)

          subject.validate

          expect(subject.errors.messages[user_type_sym]).to be_nil
        end
      end
    end
  end
end
# == Schema Information
#
# Table name: ratings
#
#  id           :integer          not null, primary key
#  from_user_id :integer
#  to_user_id   :integer
#  job_id       :integer
#  score        :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_ratings_on_job_id_and_from_user_id  (job_id,from_user_id) UNIQUE
#  index_ratings_on_job_id_and_to_user_id    (job_id,to_user_id) UNIQUE
#
# Foreign Keys
#
#  ratings_from_user_id_fk  (from_user_id => users.id)
#  ratings_job_id_fk        (job_id => jobs.id)
#  ratings_to_user_id_fk    (to_user_id => users.id)
#
