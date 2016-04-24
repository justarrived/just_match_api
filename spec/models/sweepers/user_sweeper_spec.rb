# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Sweepers::UserSweeper do
  describe '#create_frilans_finans' do
    it 'sets user frilans finans id' do
      user = FactoryGirl.create(:user, frilans_finans_id: nil)

      isolate_frilans_finans_client(FrilansFinansApi::FixtureClient) do
        described_class.create_frilans_finans
        user.reload
        expect(user.frilans_finans_id).to eq(1)
      end
    end

    it 'does nothing when frilans finans returns nil' do
      user = FactoryGirl.create(:user, frilans_finans_id: nil)

      isolate_frilans_finans_client(FrilansFinansApi::NilClient) do
        described_class.create_frilans_finans
        user.reload
        expect(user.frilans_finans_id).to be_nil
      end
    end
  end
end
