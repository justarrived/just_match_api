# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobDigestMailer, type: :mailer do
  let(:email) { 'watman@example.com' }
  let(:jobs) do
    [
      mock_model(
        Job,
        id: 1,
        translated_name: 'Job1',
        translated_short_description: 'Description1'
      ),
      mock_model(
        Job,
        id: 2,
        translated_name: 'Job2',
        translated_short_description: 'Description2'
      ),
      mock_model(
        Job,
        id: 3,
        translated_name: 'Job3',
        translated_short_description: 'Description3'
      )
    ]
  end

  let(:job_digest) do
    mock_model(
      JobDigest,
      digest_subscriber_id: 87,
      email: email,
      addresses: [],
      coordinates?: false,
      user: mock_model(User)
    )
  end

  describe '#new_job_digest_email' do
    let(:mail) do
      described_class.digest_email(jobs: jobs, job_digest: job_digest)
    end

    it 'has both text and html part' do
      expect(mail).to be_multipart_email(true)
    end

    it 'renders the subject' do
      subject = I18n.t('mailer.digest_email.subject')
      expect(mail.subject).to eql(subject)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['no-reply@justarrived.se'])
    end

    it 'includes job translated names in email body' do
      jobs.each do |job|
        expect(mail).to match_email_body(job.translated_name)
      end
    end

    it 'includes job translated short descriptions in email body' do
      jobs.each do |job|
        expect(mail).to match_email_body(job.translated_short_description)
      end
    end

    it 'includes job links in email body' do
      jobs.each do |job|
        link = FrontendRouter.draw(:job, id: job.id, utm_campaign: 'digest_email')
        expect(mail).to match_email_body(link)
      end
    end

    it 'includes more jobs link in email body' do
      link = FrontendRouter.draw(:jobs, utm_campaign: 'digest_email')
      expect(mail).to match_email_body(link)
    end

    it 'includes unsubscribe link in email body' do
      link = FrontendRouter.draw(:unsubscribe,
                                 subscriber_id: job_digest.digest_subscriber_id,
                                 utm_campaign: 'digest_email')
      expect(mail).to match_email_body(link)
    end

    it 'includes location settings in email body if there are *no* coordinates' do
      message = I18n.t('mailer.digest_email.no_digest_address_setting_notice')
      expect(mail).to match_email_body(message)
    end

    context 'with address coordinates' do
      let(:job_digest) do
        mock_model(
          JobDigest,
          digest_subscriber_id: 87,
          email: email,
          addresses: [],
          coordinates?: true,
          user: mock_model(User)
        )
      end

      it 'does not include location settings in email body if there are coordinates' do
        message = I18n.t('mailer.digest_email.no_digest_address_setting_notice')
        expect(mail).not_to match_email_body(message)
      end
    end
  end

  describe '#digest_created_email' do
    let(:mail) do
      described_class.digest_created_email(job_digest: job_digest)
    end

    it 'has both text and html part' do
      expect(mail).to be_multipart_email(true)
    end

    it 'renders the subject' do
      subject = I18n.t('mailer.digest_created.subject')
      expect(mail.subject).to eql(subject)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['no-reply@justarrived.se'])
    end

    it 'includes unsubscribe link in email body' do
      link = FrontendRouter.draw(:unsubscribe,
                                 subscriber_id: job_digest.digest_subscriber_id,
                                 utm_campaign: 'digest_created')
      expect(mail).to match_email_body(link)
    end
  end
end
