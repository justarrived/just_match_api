# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobUserMailer, type: :mailer do
  let(:user) do
    tel = '+46735000000'
    mail = 'user@example.com'
    mock_model(User, first_name: 'User', name: 'User', contact_email: mail, phone: tel)
  end
  let(:ja_contact) do
    tel = '+46735000000'
    mail = 'user@example.com'
    mock_model(User, first_name: 'User', name: 'User', email: mail, phone: tel)
  end
  let(:job_user) { mock_model JobUser, user: user, job: job, id: 37 }
  let(:job) do
    mock_model(
      Job,
      name: 'Job name',
      address: 'Sveavägen 1',
      job_date: 1.day.ago,
      job_end_date: 2.days.ago,
      just_arrived_contact: ja_contact,
      hours: 2,
      gross_amount: 200,
      hourly_gross_salary: 100,
      google_calendar_template_url: 'http://google.calendar.example.com',
      hourly_pay: mock_model(HourlyPay, gross_salary: 100)
    )
  end

  describe '#new_applicant_job_info_email' do
    let(:skill) { FactoryGirl.create(:skill) }
    let(:language) { FactoryGirl.create(:language) }
    let(:mail) do
      described_class.new_applicant_job_info_email(
        job_user: job_user, skills: [skill], languages: [language]
      )
    end

    it 'has both text and html part' do
      expect(mail).to be_multipart_email(true)
    end

    it 'renders the subject' do
      subject = I18n.t('mailer.new_applicant_job_info.subject')
      expect(mail.subject).to eql(subject)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.contact_email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['support@email.justarrived.se'])
    end

    it 'includes @user_name in email body' do
      expect(mail).to match_email_body(user.name)
    end

    it 'includes @job_name in email body' do
      expect(mail).to match_email_body(job.name)
    end

    it 'includes skill names in email body' do
      expect(mail).to match_email_body(skill.name)
    end
  end

  describe '#update_data_reminder_email' do
    let(:skill) { FactoryGirl.create(:skill) }
    let(:language) { FactoryGirl.create(:language) }
    let(:mail) do
      described_class.update_data_reminder_email(
        job_user: job_user, skills: [skill], languages: [language]
      )
    end

    it 'has both text and html part' do
      expect(mail).to be_multipart_email(true)
    end

    it 'renders the subject' do
      subject = I18n.t('mailer.update_data_reminder.subject')
      expect(mail.subject).to eql(subject)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.contact_email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['support@email.justarrived.se'])
    end

    it 'includes @job_url in email body' do
      url = FrontendRouter.draw(:job, id: job.id)
      expect(mail).to match_email_body(url)
    end

    it 'includes @profile_update_url in email body' do
      url = FrontendRouter.draw(:user_edit)
      expect(mail).to match_email_body(url)
    end

    it 'includes cv update info in email body' do
      expect(mail).to match_email_body('CV')
    end

    it 'includes @job_name in email body' do
      # we truncate the job name in the email so
      # lets check only the first part
      job_name = job.name[0..10]
      expect(mail).to match_email_body(job_name)
    end

    it 'includes skill names in email body' do
      expect(mail).to match_email_body(skill.name)
    end
  end
end
