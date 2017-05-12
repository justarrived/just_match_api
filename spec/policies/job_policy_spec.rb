# frozen_string_literal: true
require 'rails_helper'

RSpec.describe JobPolicy do
  before(:each) do
    allow_any_instance_of(User).to receive(:persisted?).and_return(true)
  end

  let(:owner_params) do
    [
      :description, :job_date, :street, :zip, :name, :hours, :job_end_date,
      :cancelled, :city, :filled, :short_description, :featured, :upcoming,
      :currency, :gross_amount_delimited, :net_amount_delimited, :full_street_address,
      :staffing_job, :description_html, :direct_recruitment_job, :owner_user_id,
      :swedish_drivers_license, :car_required, :last_application_at,
      :language_id, :category_id, :hourly_pay_id, { skill_ids: [] }
    ]
  end
  let(:admin_params) { owner_params }

  context 'with anyone' do
    subject { JobPolicy.new(nil, job) }

    let(:job) { FactoryGirl.build(:job) }

    it '#index? returns true' do
      expect(subject.index?).to eq(true)
    end

    it '#show? returns true' do
      expect(subject.show?).to eq(true)
    end

    it '#google? returns true' do
      expect(subject.google?).to eq(true)
    end

    it '#create? returns false' do
      expect(subject.create?).to eq(false)
    end

    it '#create? returns true if ENV-config is set' do
      allow(AppConfig).to receive(:allow_regular_users_to_create_jobs?).and_return(true)
      expect(subject.create?).to eq(true)
    end

    it '#update? returns false' do
      expect(subject.update?).to eq(false)
    end

    it '#matching_users? returns false' do
      expect(subject.matching_users?).to eq(false)
    end

    it '#permitted_attributes is correct for persisted job' do
      persisted_job = FactoryGirl.create(:job)
      policy = JobPolicy.new(nil, persisted_job)
      expect(policy.permitted_attributes).to eq([])
    end

    it 'returns false for #present_applicants?' do
      expect(subject.present_applicants?).to eq(false)
    end

    it 'returns false for #present_self_applicant?' do
      expect(subject.present_self_applicant?).to eq(false)
    end
  end

  context 'with company user' do
    subject { JobPolicy.new(user, job) }

    let(:company) { FactoryGirl.build(:company) }
    let(:user) { FactoryGirl.build(:user, company: company) }
    let(:job) { FactoryGirl.build(:job) }

    it '#create? returns true' do
      expect(subject.create?).to eq(true)
    end
  end

  context 'with user' do
    subject { JobPolicy.new(user, job) }

    let(:user) { FactoryGirl.build(:user) }
    let(:job) { FactoryGirl.build(:job) }

    it '#create? returns true' do
      expect(subject.create?).to eq(false)
    end

    it '#update? returns true' do
      expect(subject.update?).to eq(false)
    end

    it '#matching_users? returns false' do
      expect(subject.matching_users?).to eq(false)
    end

    it '#permitted_attributes is correct for non-persisted job' do
      expect(subject.permitted_attributes).to match(owner_params)
    end

    it '#permitted_attributes is correct for persisted job' do
      persisted_job = FactoryGirl.create(:job)
      policy = JobPolicy.new(user, persisted_job)
      expect(policy.permitted_attributes).to eq([])
    end

    it 'returns false for #present_applicants?' do
      expect(subject.present_applicants?).to eq(false)
    end

    it 'returns false for #present_self_applicant?' do
      expect(subject.present_self_applicant?).to eq(false)
    end
  end

  context 'with accepted applicant user' do
    subject { JobPolicy.new(user, job) }

    let(:user) { FactoryGirl.create(:user) }
    let(:job) { FactoryGirl.create(:job) }

    it '#update? returns false' do
      job.users = [user]
      job.accept_applicant!(user)
      expect(subject.update?).to eq(false)
    end

    it '#permitted_attributes is correct' do
      job.users = [user]
      job.accept_applicant!(user)
      expect(subject.permitted_attributes).to eq([])
    end

    it 'returns false for #present_applicants?' do
      job.users = [user]
      job.accept_applicant!(user)
      expect(subject.present_applicants?).to eq(false)
    end

    it 'returns true for #present_self_applicant?' do
      job.users = [user]
      job.accept_applicant!(user)
      expect(subject.present_self_applicant?).to eq(true)
    end
  end

  context 'with owner user' do
    subject { JobPolicy.new(user, job) }

    let(:user) { FactoryGirl.build(:user) }
    let(:job) { FactoryGirl.build(:job, owner: user) }

    it '#matching_users? returns true' do
      expect(subject.matching_users?).to eq(true)
    end

    it '#permitted_attributes is correct for persisted job' do
      persisted_job = FactoryGirl.create(:job)
      policy = JobPolicy.new(nil, persisted_job)
      expect(policy.permitted_attributes).to eq([])
    end

    it 'returns true for #present_applicants?' do
      expect(subject.present_applicants?).to eq(true)
    end

    it 'returns false for #present_self_applicant?' do
      expect(subject.present_self_applicant?).to eq(false)
    end
  end

  context 'with admin user' do
    subject { JobPolicy.new(admin, job) }

    let(:admin) { FactoryGirl.build(:admin_user) }
    let(:job) { FactoryGirl.build(:job) }

    it '#matching_users? returns true' do
      expect(subject.matching_users?).to eq(true)
    end

    it '#permitted_attributes is correct for non-persisted job' do
      expect(subject.permitted_attributes).to match(admin_params)
    end

    it 'returns true for #present_applicants?' do
      expect(subject.present_applicants?).to eq(true)
    end

    it 'returns false for #present_self_applicant?' do
      expect(subject.present_self_applicant?).to eq(false)
    end
  end

  describe 'scope' do
    let(:admin) { FactoryGirl.build(:admin_user) }
    let(:user) { FactoryGirl.build(:user) }
    let(:job) { FactoryGirl.build(:job) }

    context 'user' do
      subject { JobPolicy.new(user, job) }

      it 'returns all visible jobs' do
        FactoryGirl.create(:job, hidden: true)
        FactoryGirl.create(:job)
        expect(subject.scope.length).to eq(1)
      end
    end
  end
end
