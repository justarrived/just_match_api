# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  let(:user) { mock_model User, name: 'User', email: 'user@example.com' }
  let(:owner) { mock_model User, name: 'Owner', email: 'owner@example.com' }
  let(:job) { mock_model Job, name: 'Job name' }

  describe '#welcome_email' do
    let(:mail) { UserMailer.welcome_email(user: user) }

    it 'has both text and html part' do
      expect(mail).to be_multipart_email(true)
    end

    it 'renders the subject' do
      expect(mail.subject).to eql('Welcome to Just Arrived!')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['hello@justarrived.se'])
    end

    it 'invludes @user_name in email body' do
      expect(mail).to match_email_body(user.name)
    end
  end

  describe '#job_match_email' do
    let(:mail) do
      UserMailer.job_match_email(job: job, user: user, owner: owner)
    end

    it 'has both text and html part' do
      expect(mail).to be_multipart_email(true)
    end

    it 'renders the subject' do
      expect(mail.subject).to eql('Congrats! You have a new job match.')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['hello@justarrived.se'])
    end

    it 'invludes @user_name in email body' do
      expect(mail).to match_email_body(user.name)
    end

    it 'invludes @owner_email in email body' do
      expect(mail).to match_email_body(owner.email)
    end

    it 'invludes @job_name in email body' do
      expect(mail).to match_email_body(job.name)
    end
  end

  describe '#job_user_performed_accepted_email' do
    let(:mail) do
      UserMailer.job_user_performed_accepted_email(job: job, user: user, owner: owner)
    end

    it 'has both text and html part' do
      expect(mail).to be_multipart_email(true)
    end

    it 'renders the subject' do
      subject = 'Congrats! A job you performed has been accepted.'
      expect(mail.subject).to eql(subject)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['hello@justarrived.se'])
    end

    it 'invludes @user_name in email body' do
      expect(mail).to match_email_body(user.name)
    end

    it 'invludes @owner_name in email body' do
      expect(mail).to match_email_body(owner.name)
    end

    it 'invludes @job_name in email body' do
      expect(mail).to match_email_body(job.name)
    end
  end

  describe '#job_user_performed_email' do
    let(:mail) do
      UserMailer.job_user_performed_email(job: job, user: user, owner: owner)
    end

    it 'has both text and html part' do
      expect(mail).to be_multipart_email(true)
    end

    it 'renders the subject' do
      subject = 'Congrats! A job you ordered has been performed.'
      expect(mail.subject).to eql(subject)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([owner.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['hello@justarrived.se'])
    end

    it 'invludes @user_name in email body' do
      expect(mail).to match_email_body(user.name)
    end

    it 'invludes @owner_name in email body' do
      expect(mail).to match_email_body(owner.name)
    end

    it 'invludes @job_name in email body' do
      expect(mail).to match_email_body(job.name)
    end
  end

  describe '#new_applicant_email' do
    let(:mail) do
      UserMailer.new_applicant_email(job: job, user: user, owner: owner)
    end

    it 'has both text and html part' do
      expect(mail).to be_multipart_email(true)
    end

    it 'renders the subject' do
      subject = 'Congrats! You have a new applicant.'
      expect(mail.subject).to eql(subject)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([owner.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['hello@justarrived.se'])
    end

    it 'invludes @user_name in email body' do
      expect(mail).to match_email_body(user.name)
    end

    it 'invludes @owner_name in email body' do
      expect(mail).to match_email_body(owner.name)
    end

    it 'invludes @job_name in email body' do
      expect(mail).to match_email_body(job.name)
    end
  end

  describe '#applicant_accepted_email' do
    let(:mail) do
      UserMailer.applicant_accepted_email(job: job, user: user, owner: owner)
    end

    it 'has both text and html part' do
      expect(mail).to be_multipart_email(true)
    end

    it 'renders the subject' do
      subject = 'Congrats! You got a job.'
      expect(mail.subject).to eql(subject)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['hello@justarrived.se'])
    end

    it 'invludes @user_name in email body' do
      expect(mail).to match_email_body(user.name)
    end

    it 'invludes @owner_email in email body' do
      expect(mail).to match_email_body(owner.email)
    end

    it 'invludes @job_name in email body' do
      expect(mail).to match_email_body(job.name)
    end
  end

  describe '#applicant_will_perform_email' do
    let(:mail) do
      UserMailer.applicant_will_perform_email(job: job, user: user, owner: owner)
    end

    it 'has both text and html part' do
      expect(mail).to be_multipart_email(true)
    end

    it 'renders the subject' do
      subject = 'Congrats! The applicant will perform your job.'
      expect(mail.subject).to eql(subject)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([owner.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['hello@justarrived.se'])
    end

    it 'invludes @user_name in email body' do
      expect(mail).to match_email_body(user.name)
    end

    it 'invludes @job_name in email body' do
      expect(mail).to match_email_body(job.name)
    end
  end

  describe '#accepted_applicant_withdrawn_email' do
    let(:mail) do
      UserMailer.accepted_applicant_withdrawn_email(job: job, user: user, owner: owner)
    end

    it 'has both text and html part' do
      expect(mail).to be_multipart_email(true)
    end

    it 'renders the subject' do
      subject = 'An accepted user for your job has withdrawn their application.'
      expect(mail.subject).to eql(subject)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([owner.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['hello@justarrived.se'])
    end

    it 'invludes @user_name in email body' do
      expect(mail).to match_email_body(user.name)
    end

    it 'invludes @job_name in email body' do
      expect(mail).to match_email_body(job.name)
    end
  end

  describe '#accepted_applicant_confirmation_overdue_email' do
    let(:mail) do
      UserMailer.accepted_applicant_confirmation_overdue_email(
        job: job, user: user, owner: owner
      )
    end

    it 'has both text and html part' do
      expect(mail).to be_multipart_email(true)
    end

    it 'renders the subject' do
      subject = 'An accepted user for your job has not confirmed in time.'
      expect(mail.subject).to eql(subject)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([owner.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['hello@justarrived.se'])
    end

    it 'invludes @user_name in email body' do
      expect(mail).to match_email_body(user.name)
    end

    it 'invludes @job_name in email body' do
      expect(mail).to match_email_body(job.name)
    end
  end

  describe '#reset_password_email' do
    let(:user) { FactoryGirl.build(:user_with_one_time_token) }
    let(:mail) { UserMailer.reset_password_email(user: user) }

    it 'has both text and html part' do
      expect(mail).to be_multipart_email(true)
    end

    it 'renders the subject' do
      subject = I18n.t('mailer.reset_password.subject')
      expect(mail.subject).to eql(subject)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['hello@justarrived.se'])
    end

    it 'invludes @user_name in email body' do
      expect(mail).to match_email_body(user.first_name)
    end

    it 'includes users reset password url' do
      url = FrontendRouter.fetch(:reset_password, token: user.one_time_token)
      expect(mail).to match_email_body(url)
    end
  end

  describe '#changed_password_email' do
    let(:user) { FactoryGirl.build(:user) }
    let(:mail) { UserMailer.changed_password_email(user: user) }

    it 'has both text and html part' do
      expect(mail).to be_multipart_email(true)
    end

    it 'renders the subject' do
      subject = I18n.t('mailer.changed_password.subject')
      expect(mail.subject).to eql(subject)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['hello@justarrived.se'])
    end

    it 'invludes @user_name in email body' do
      expect(mail).to match_email_body(user.first_name)
    end
  end
end
