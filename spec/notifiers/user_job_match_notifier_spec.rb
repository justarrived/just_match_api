require 'rails_helper'

RSpec.describe UserJobMatchNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }

  it 'must work' do
    allow(UserMailer).to receive(:job_match_email).and_return(mailer)
    UserJobMatchNotifier.call(user: nil, job: nil, owner: nil)
    expect(UserMailer).to have_received(:job_match_email)
  end
end
