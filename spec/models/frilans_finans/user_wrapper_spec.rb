# frozen_string_literal: true
require 'rails_helper'

RSpec.describe FrilansFinans::UserWrapper do
  describe '::attributes' do
    let(:account_clearing_number) { '8000-2' }
    let(:account_number) { '0000000000' }

    it 'returns the correct attributes' do
      id = 73
      user = FactoryGirl.build(
        :user,
        id: 73,
        ssn: '890101-0101',
        account_clearing_number: account_clearing_number,
        account_number: account_number,
        language: FactoryGirl.build(:language)
      )
      result = described_class.attributes(user)
      expected = {
        email: user.email,
        street: user.street,
        city: user.city,
        zip: user.zip,
        country: 'SWEDEN',
        cellphone: user.phone,
        first_name: user.first_name,
        last_name: user.last_name,
        social_security_number: '8901010101',
        account_clearing_number: account_clearing_number,
        account_number: account_number,
        notification_language: 'en',
        receive_email_notifications: false,
        receive_sms_notificiations: false,
        remote_id: id.to_s,
        show_name_in_network: false
      }
      expect(result).to eq(expected)
    end

    context 'when ssn is nil' do
      it 'returns no social_security_number key' do
        user = FactoryGirl.build(:user, ssn: nil, language: FactoryGirl.build(:language))
        result = described_class.attributes(user)
        expect(result.key?(:social_security_number)).to eq(false)
      end
    end

    context 'when ssn is blank string' do
      it 'returns no social_security_number key' do
        user = FactoryGirl.build(:user, ssn: ' ', language: FactoryGirl.build(:language))
        result = described_class.attributes(user)
        expect(result.key?(:social_security_number)).to eq(false)
      end
    end

    it 'returns the empty street string if no street present' do
      user = FactoryGirl.build(:user, street: nil, language: FactoryGirl.build(:language))
      result = described_class.attributes(user)
      expect(result[:street]).to eq('')
    end

    it 'returns the empty zip string if no zip present' do
      user = FactoryGirl.build(:user, zip: nil, language: FactoryGirl.build(:language))
      result = described_class.attributes(user)
      expect(result[:zip]).to eq('')
    end
  end

  describe '::format_ssn' do
    it 'returns formetted ssn' do
      expect(described_class.format_ssn('890101-0101')).to eq('8901010101')
    end
  end

  describe '::notification_language' do
    it 'returns SE if language is Swedish' do
      sv_lang = FactoryGirl.build(:language, lang_code: 'sv')
      expect(described_class.notification_language(sv_lang)).to eq('sv')
    end

    it 'returns EN for non-Swedish languages' do
      lang = FactoryGirl.build(:language)
      expect(described_class.notification_language(lang)).to eq('en')
    end
  end
end
