# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Sweepers::TokenSweeper do
  describe '#destroy_expired_tokens' do
    it 'destroys all expired tokens' do
      FactoryGirl.create(:token, expires_at: 1.day.ago)
      FactoryGirl.create(:token, expires_at: 1.hour.ago)
      FactoryGirl.create(:token)

      expect do
        described_class.destroy_expired_tokens
      end.to change(Token, :count).by(-2)
    end
  end
end
