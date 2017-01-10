# frozen_string_literal: true
require 'rails_helper'

RSpec.describe JobMailer, type: :mailer do
  let(:user) do
    tel = '+46735000000'
    mail = 'user@example.com'
    mock_model(User, first_name: 'User', name: 'User', contact_email: mail, phone: tel)
  end
  let(:owner) { mock_model User, name: 'Owner', contact_email: 'owner@example.com' }
  let(:job_user) { mock_model JobUser, user: user, job: job, id: 37 }
  let(:job) do
    mock_model(
      Job,
      name: 'Job name',
      address: 'Sveavägen 1',
      job_date: 1.day.ago,
      job_end_date: 2.days.ago,
      hours: 2,
      gross_amount: 200,
      hourly_gross_salary: 100,
      google_calendar_template_url: 'http://google.calendar.example.com',
      hourly_pay: mock_model(HourlyPay, gross_salary: 100)
    )
  end

  describe '#job_match_email' do
    let(:mail) do
      described_class.job_match_email(job: job, user: user, owner: owner)
    end

    it 'has both text and html part' do
      expect(mail).to be_multipart_email(true)
    end

    it 'renders the subject' do
      expect(mail.subject).to eql(I18n.t('mailer.job_match.subject'))
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.contact_email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['support@justarrived.se'])
    end

    it 'includes @user_name in email body' do
      expect(mail).to match_email_body(user.name)
    end

    it 'includes @owner_email in email body' do
      expect(mail).to match_email_body(owner.contact_email)
    end

    it 'includes @job_name in email body' do
      expect(mail).to match_email_body(job.name)
    end

    it 'includes faqs url in email' do
      url = FrontendRouter.draw(:job, id: job.id)
      expect(mail).to match_email_body(url)
    end
  end

  describe '#job_user_performed_email' do
    let(:mail) do
      described_class.job_user_performed_email(job_user: job_user, owner: owner)
    end

    it 'has both text and html part' do
      expect(mail).to be_multipart_email(true)
    end

    it 'renders the subject' do
      subject = I18n.t('mailer.job_performed.subject')
      expect(mail.subject).to eql(subject)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([owner.contact_email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['support@justarrived.se'])
    end

    it 'includes @user_name in email body' do
      expect(mail).to match_email_body(job_user.user.name)
    end

    it 'includes @owner_name in email body' do
      expect(mail).to match_email_body(owner.name)
    end

    it 'includes @job_name in email body' do
      expect(mail).to match_email_body(job_user.job.name)
    end

    it 'includes job user url in email' do
      url = FrontendRouter.draw(
        :job_user_for_company,
        job_id: job.id,
        job_user_id: job_user.id
      )
      expect(mail).to match_email_body(url)
    end
  end

  describe '#new_applicant_email' do
    let(:mail) do
      described_class.new_applicant_email(job_user: job_user, owner: owner)
    end

    it 'has both text and html part' do
      expect(mail).to be_multipart_email(true)
    end

    it 'renders the subject' do
      subject = I18n.t('mailer.new_applicant.subject')
      expect(mail.subject).to eql(subject)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([owner.contact_email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['support@justarrived.se'])
    end

    it 'includes @user_name in email body' do
      expect(mail).to match_email_body(user.name)
    end

    it 'includes @owner_name in email body' do
      expect(mail).to match_email_body(owner.name)
    end

    it 'includes @job_name in email body' do
      expect(mail).to match_email_body(job.name)
    end

    it 'includes job user url in email' do
      url = FrontendRouter.draw(
        :job_user_for_company,
        job_id: job.id,
        job_user_id: job_user.id
      )
      expect(mail).to match_email_body(url)
    end
  end

  describe '#applicant_accepted_email' do
    let(:mail) do
      described_class.applicant_accepted_email(job_user: job_user, owner: owner)
    end

    it 'has both text and html part' do
      expect(mail).to be_multipart_email(true)
    end

    it 'renders the subject' do
      subject = I18n.t('mailer.applicant_accepted.subject')
      expect(mail.subject).to eql(subject)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.contact_email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['support@justarrived.se'])
    end

    it 'includes @user_name in email body' do
      expect(mail).to match_email_body(user.first_name)
    end

    it 'includes @confirmation_time_hours in email body' do
      expect(mail).to match_email_body(JobUser::MAX_CONFIRMATION_TIME_HOURS.to_s)
    end

    it 'includes @confirmation_time_hours in email body' do
      expect(mail).to match_email_body(JobUser::MAX_CONFIRMATION_TIME_HOURS.to_s)
    end

    it 'includes @total_hours in email body' do
      expect(mail).to match_email_body(job.hours.to_s)
    end

    it 'includes @hourly_gross_salary in email body' do
      expect(mail).to match_email_body(job.hourly_gross_salary.to_s)
    end

    it 'includes @total_salary in email body' do
      expect(mail).to match_email_body(job.gross_amount.to_s)
    end

    it 'includes @job_address in email body' do
      expect(mail).to match_email_body(job.address)
    end

    it 'includes job user url in email' do
      url = FrontendRouter.draw(:job_user, job_id: job.id)
      expect(mail).to match_email_body(url)
    end
  end

  describe '#applicant_will_perform_email' do
    let(:mail) do
      described_class.applicant_will_perform_email(job_user: job_user, owner: owner)
    end

    it 'has both text and html part' do
      expect(mail).to be_multipart_email(true)
    end

    it 'renders the subject' do
      subject = I18n.t('mailer.applicant_will_perform.subject')
      expect(mail.subject).to eql(subject)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([owner.contact_email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['support@justarrived.se'])
    end

    it 'includes @user_name in email body' do
      expect(mail).to match_email_body(user.name)
    end

    it 'includes @user_email in email body' do
      expect(mail).to match_email_body(user.contact_email)
    end

    it 'includes @user_phone in email body' do
      expect(mail).to match_email_body(user.phone)
    end

    it 'includes @job_name in email body' do
      expect(mail).to match_email_body(job.name)
    end

    it 'includes job user url in email' do
      url = FrontendRouter.draw(
        :job_user_for_company,
        job_id: job.id,
        job_user_id: job_user.id
      )
      expect(mail).to match_email_body(url)
    end
  end

  describe '#applicant_rejected_email' do
    let(:mail) do
      described_class.applicant_rejected_email(job_user: job_user)
    end

    it 'has both text and html part' do
      expect(mail).to be_multipart_email(true)
    end

    it 'renders the subject' do
      subject = I18n.t('mailer.applicant_rejected.subject')
      expect(mail.subject).to eql(subject)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([job_user.user.contact_email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['support@justarrived.se'])
    end

    it 'includes @job_name in email body' do
      expect(mail).to match_email_body(job.name)
    end
  end

  describe '#accepted_applicant_withdrawn_email' do
    let(:mail) do
      described_class.accepted_applicant_withdrawn_email(job_user: job_user, owner: owner)
    end

    it 'has both text and html part' do
      expect(mail).to be_multipart_email(true)
    end

    it 'renders the subject' do
      subject = I18n.t('mailer.accepted_applicant_withdrawn.subject')
      expect(mail.subject).to eql(subject)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([owner.contact_email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['support@justarrived.se'])
    end

    it 'includes @user_name in email body' do
      expect(mail).to match_email_body(user.name)
    end

    it 'includes @job_name in email body' do
      expect(mail).to match_email_body(job.name)
    end
  end

  describe '#accepted_applicant_confirmation_overdue_email' do
    let(:mail) do
      described_class.accepted_applicant_confirmation_overdue_email(
        job_user: job_user, owner: owner
      )
    end

    it 'has both text and html part' do
      expect(mail).to be_multipart_email(true)
    end

    it 'renders the subject' do
      subject = I18n.t('mailer.accepted_applicant_confirmation_overdue.subject')
      expect(mail.subject).to eql(subject)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([owner.contact_email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['support@justarrived.se'])
    end

    it 'includes @user_name in email body' do
      expect(mail).to match_email_body(user.name)
    end

    it 'includes @job_name in email body' do
      expect(mail).to match_email_body(job.name)
    end

    it 'includes job user url in email' do
      url = FrontendRouter.draw(:job_users, job_id: job.id)
      expect(mail).to match_email_body(url)
    end
  end

  describe '#job_cancelled_email' do
    let(:user) { FactoryGirl.build(:user) }
    let(:job) { FactoryGirl.build(:job) }
    let(:mail) { described_class.job_cancelled_email(user: user, job: job) }

    it 'has both text and html part' do
      expect(mail).to be_multipart_email(true)
    end

    it 'renders the subject' do
      subject = I18n.t('mailer.job_cancelled.subject')
      expect(mail.subject).to eql(subject)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.contact_email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['support@justarrived.se'])
    end

    it 'includes @job_name in email body' do
      expect(mail).to match_email_body(job.name)
    end

    it 'includes jobs url in email' do
      url = FrontendRouter.draw(:jobs)
      expect(mail).to match_email_body(url)
    end
  end

  describe '#new_job_comment_email' do
    let(:owner) { FactoryGirl.build(:user) }
    let(:job) { FactoryGirl.build(:job, owner: owner) }
    let(:comment) { FactoryGirl.build(:comment) }
    let(:mail) { described_class.new_job_comment_email(comment: comment, job: job) }

    it 'has both text and html part' do
      expect(mail).to be_multipart_email(true)
    end

    it 'renders the subject' do
      subject = I18n.t('mailer.new_job_comment.subject')
      expect(mail.subject).to eql(subject)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([owner.contact_email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['support@justarrived.se'])
    end

    it 'includes job url in email' do
      url = FrontendRouter.draw(:job, id: job.id)
      expect(mail).to match_email_body(url)
    end
  end
end
