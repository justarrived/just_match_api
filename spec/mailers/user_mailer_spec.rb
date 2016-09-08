# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  let(:user) { mock_model User, name: 'User', contact_email: 'user@example.com' }
  let(:owner) { mock_model User, name: 'Owner', contact_email: 'owner@example.com' }
  let(:job) { mock_model Job, name: 'Job name' }

  describe '#welcome_email' do
    let(:mail) { described_class.welcome_email(user: user) }

    it 'has both text and html part' do
      expect(mail).to be_multipart_email(true)
    end

    it 'renders the subject' do
      expect(mail.subject).to eql('Welcome to Just Arrived!')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.contact_email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['hello@justarrived.se'])
    end

    it 'includes @user_name in email body' do
      expect(mail).to match_email_body(user.name)
    end

    it 'includes login url in email' do
      url = FrontendRouter.draw(:login)
      expect(mail).to match_email_body(url)
    end

    it 'includes faqs url in email' do
      url = FrontendRouter.draw(:faqs)
      expect(mail).to match_email_body(url)
    end
  end

  describe '#reset_password_email' do
    let(:user) { FactoryGirl.build(:user_with_one_time_token) }
    let(:mail) { described_class.reset_password_email(user: user) }

    it 'has both text and html part' do
      expect(mail).to be_multipart_email(true)
    end

    it 'renders the subject' do
      subject = I18n.t('mailer.reset_password.subject')
      expect(mail.subject).to eql(subject)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.contact_email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['hello@justarrived.se'])
    end

    it 'includes @user_name in email body' do
      expect(mail).to match_email_body(user.first_name)
    end

    it 'includes users reset password url' do
      url = FrontendRouter.draw(:reset_password, token: user.one_time_token)
      expect(mail).to match_email_body(url)
    end
  end

  describe '#changed_password_email' do
    let(:user) { FactoryGirl.build(:user) }
    let(:mail) { described_class.changed_password_email(user: user) }

    it 'has both text and html part' do
      expect(mail).to be_multipart_email(true)
    end

    it 'renders the subject' do
      subject = I18n.t('mailer.changed_password.subject')
      expect(mail.subject).to eql(subject)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.contact_email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['hello@justarrived.se'])
    end

    it 'includes @user_name in email body' do
      expect(mail).to match_email_body(user.first_name)
    end
  end

  describe '#magic_login_link_email' do
    let(:user) { FactoryGirl.build(:user_with_one_time_token) }
    let(:mail) { described_class.magic_login_link_email(user: user) }

    it 'has both text and html part' do
      expect(mail).to be_multipart_email(true)
    end

    it 'renders the subject' do
      subject = I18n.t('mailer.magic_login_link.subject')
      expect(mail.subject).to eql(subject)
    end

    it 'includes users reset password url' do
      url = FrontendRouter.draw(:magic_login_link, token: user.one_time_token)
      expect(mail).to match_email_body(url)
    end
  end
end
