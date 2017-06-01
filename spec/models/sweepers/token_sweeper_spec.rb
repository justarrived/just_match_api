# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sweepers::TokenSweeper do
  describe '#destroy_expired_tokens' do
    it 'destroys all tokens ready for deletion' do
      FactoryGirl.create(:token, expires_at: 1.day.ago)
      FactoryGirl.create(:token, expires_at: 8.months.ago)
      FactoryGirl.create(:token, expires_at: 7.months.ago)
      FactoryGirl.create(:token)

      expect do
        described_class.destroy_expired_tokens
      end.to change(Token, :count).by(-2)
    end
  end
end
