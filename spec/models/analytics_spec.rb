# frozen_string_literal: true
RSpec.describe Analytics do
  describe '#track_user_sign_in' do
    let(:write_key) { 'WRITE_KEY' }
    let(:analytics_backend) { described_class.backend }
    let(:fake_analytics) do
      instance = Class.new do
        def identify(*); end

        def track(*); end
      end.new
      allow(instance).to receive(:track)
      instance
    end
    let(:user) { FactoryGirl.build_stubbed(:user) }
    let(:analytics) { Analytics.new(user, client: fake_analytics) }

    describe '#track_user_sign_in' do
      it 'notifies analytics backend of a user signing in' do
        analytics.track_user_sign_in

        expect(fake_analytics).to have_received(:track).with(
          user_id: user.id,
          event: 'Sign In User'
        )
      end
    end

    describe '#track_user_creation' do
      it 'notifies analytics backend of a user creation' do
        analytics.track_user_creation

        expect(fake_analytics).to have_received(:track).with(
          user_id: user.id,
          event: 'Create User',
          properties: { zip: user.zip }
        )
      end
    end
  end
end
