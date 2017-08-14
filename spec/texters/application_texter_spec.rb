# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationTexter do
  let(:from) { '+46735000000' }
  let(:to) { '+46735000000' }
  let(:body) { 'Watwoman' }

  before(:each) do
    allow(AppSecrets).to receive(:twilio_account_sid).and_return('notsosecret')
    allow(AppSecrets).to receive(:twilio_auth_token).and_return('notsosecret')
  end

  describe '#text' do
    let(:template) { 'job_texter/applicant_accepted_text' }

    it "returns an instance of #{described_class.name}" do
      expect(described_class.text(to: to, template: template)).to be_a(ApplicationTexter)
    end

    it 'renders the template' do
      text = described_class.text(to: to, template: template)
      # Don't hesitate to update the match_content variable,
      # if the contents of the template change
      match_content = 'job'

      # This test is quite fragile, since its depends on a private instance variable,
      # but is necessary since we need to test that the template is rendered correctly.
      expect(text.instance_variable_get('@body')).to match(match_content)
    end
  end

  describe '#_pack_instance_variables' do
    let(:value) { 'Watman' }

    it 'returns a hash with all instance variables' do
      described_class.instance_variable_set('@name', value)

      expected = { 'name' => value }
      expect(described_class._pack_instance_variables).to eq(expected)
    end

    it 'ignores instance variable named @parent_name (Rails trickery..)' do
      described_class.instance_variable_set('@name', value)
      described_class.instance_variable_set('@parent_name', 'String') # Rails trickery..

      expected = { 'name' => value }
      expect(described_class._pack_instance_variables).to eq(expected)
    end

    it 'ignores instance variables prefixed with __' do
      described_class.instance_variable_set('@name', value)
      described_class.instance_variable_set('@__something', 'some')
      described_class.instance_variable_set('@__darkside', 'thing')

      expected = { 'name' => value }
      expect(described_class._pack_instance_variables).to eq(expected)
    end
  end

  describe '#deliver_now' do
    subject { described_class.new(from: from, to: to, body: body) }

    it 'sends text message' do
      subject.deliver_now
      last_message = FakeSMS.messages.last

      expect(last_message.to).to eq(to)
      expect(last_message.body).to eq(body)
    end
  end

  describe '#deliver_later' do
    subject { described_class.new(from: from, to: to, body: body) }

    it 'sends text message' do
      return_value = 'Wat'
      allow(described_class.delayed_job_klass).to(
        receive(:perform_later).
          with(from: from, to: to, body: body).
          and_return(return_value)
      )
      result = subject.deliver_later

      expect(result).to eq(return_value)
    end
  end
end
