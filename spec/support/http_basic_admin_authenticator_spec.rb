# frozen_string_literal: true
require 'rails_helper'

RSpec.describe HttpBasicAdminAuthenticator do
  class TestHttpAuthModule
    EMAIL = 'admin@example.com'
    PASSWORD = '12345678'

    include HttpBasicAdminAuthenticator

    def authenticate_or_request_with_http_basic
      yield(EMAIL, PASSWORD)
    end
  end

  describe '#authenticate_admin' do
    subject { TestHttpAuthModule.new.send(:authenticate_admin) }
    let(:email) { TestHttpAuthModule::EMAIL }
    let(:password) { TestHttpAuthModule::PASSWORD }

    it 'returns admin when correct email and password' do
      admin = FactoryGirl.create(:admin_user, email: email, password: password)
      expect(subject).to eq(admin)
    end

    it 'returns nil when incorrect email or password' do
      admin = FactoryGirl.create(:admin_user, email: email, password: 'wrongpassword')
      expect(subject).to be_nil
    end
  end
end
