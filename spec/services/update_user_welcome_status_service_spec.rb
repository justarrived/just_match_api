# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateUserWelcomeAppStatusService do
  describe '#call' do
    before(:each) do
      allow_any_instance_of(WelcomeApp::Client).to receive(:user_exist?).and_return(true)
    end

    let(:user) do
      FactoryGirl.create(
        :user,
        email: 'buren@example.com',
        has_welcome_app_account: true,
        welcome_app_last_checked_at: 1.year.ago,
        updated_at: 2.weeks.ago
      )
    end

    it 'updates welcome_app_last_checked_at' do
      frozen_time = Time.zone.now
      Timecop.freeze(frozen_time) do
        updated_user = UpdateUserWelcomeAppStatusService.call(user: user)
        expect(updated_user.welcome_app_last_checked_at).to eq(frozen_time)
      end
    end

    it 'updates welcome_app_last_checked_at' do
      last_updated_at = user.updated_at
      frozen_time = Time.zone.now
      Timecop.freeze(frozen_time) do
        updated_user = UpdateUserWelcomeAppStatusService.call(user: user)
        expect(updated_user.updated_at).to eq(last_updated_at)
      end
    end

    it 'updates welcome_app_last_checked_at' do
      updated_user = UpdateUserWelcomeAppStatusService.call(user: user)
      expect(updated_user.has_welcome_app_account).to eq(true)
    end
  end
end
