# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sweepers::CompanySweeper do
  let(:a_user) { FactoryGirl.create(:user, frilans_finans_id: nil) }
  let(:user) { FactoryGirl.create(:user, frilans_finans_id: 10) }

  describe '#create_frilans_finans' do
    it 'sets company frilans finans id' do
      isolate_frilans_finans_client(FrilansFinansAPI::FixtureClient) do
        company = FactoryGirl.create(:company, users: [user, a_user])

        described_class.create_frilans_finans
        company.reload
        expect(company.frilans_finans_id).to eq(1)
      end
    end

    it 'does nothing when frilans finans returns nil' do
      company = FactoryGirl.create(:company, users: [user, a_user])

      isolate_frilans_finans_client(FrilansFinansAPI::NilClient) do
        described_class.create_frilans_finans
        company.reload
        expect(company.frilans_finans_id).to be_nil
      end
    end
  end
end
