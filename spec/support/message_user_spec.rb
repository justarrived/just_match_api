# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MessageUser do
  describe '#call' do
    it 'can work' do
      type = 'email' # must be email, sms, or both
      user = FactoryGirl.build(:user)
      template = ''
      subject = ''
      data = {}

      service = described_class.new(type, user, template, subject, data)

      expect(service.call[:success]).to eq(true)
    end

    it 'can error' do
      type = 'email' # must be email, sms, or both
      user = FactoryGirl.build(:user)
      template = 'Hi %<name>s'
      subject = ''
      data = {}

      service = described_class.new(type, user, template, subject, data)

      expect(service.call[:success]).to eq(false)
    end
  end
end
