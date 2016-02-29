# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Rating, type: :model do
  describe '#comment_owned_by' do
    let(:from_user) { FactoryGirl.create(:user) }
    let(:to_user) { FactoryGirl.create(:user) }

    subject do
      FactoryGirl.build(
        :rating,
        from_user: from_user,
        to_user: to_user,
        comment: comment
      )
    end

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

      it 'adds nothing to errors' do
        expect(subject.errors.messages[:comment]).to eq(nil)
      end
    end
  end
end
# rubocop:disable Metrics/LineLength
#
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
#  index_ratings_on_from_user_id_and_to_user_id_and_job_id  (from_user_id,to_user_id,job_id) UNIQUE
#  index_ratings_on_to_user_id_and_from_user_id_and_job_id  (to_user_id,from_user_id,job_id) UNIQUE
#
