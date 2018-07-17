# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewJobCommentNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }
  let(:job) { FactoryBot.create(:job) }
  let(:comment) { FactoryBot.create(:comment) }

  it 'sends notifications' do
    allow(JobMailer).to receive(:new_job_comment_email).and_return(mailer)
    described_class.call(comment: comment, job: job)
    expect(JobMailer).to have_received(:new_job_comment_email).once
  end
end
