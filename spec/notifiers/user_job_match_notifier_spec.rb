# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UserJobMatchNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }
  let(:job) { mock_model Job, owner: owner }
  let(:user) { FactoryGirl.build(:user) }
  let(:owner) { FactoryGirl.build(:user) }

  it 'must work' do
    allow(UserMailer).to receive(:job_match_email).and_return(mailer)
    UserJobMatchNotifier.call(user: user, job: job, owner: owner)
    mailer_args = { job: job, user: user, owner: owner }
    expect(UserMailer).to have_received(:job_match_email).with(mailer_args)
  end
end
