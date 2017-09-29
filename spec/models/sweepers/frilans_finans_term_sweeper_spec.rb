# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sweepers::FrilansFinansTermSweeper do
  describe '#create_frilans_finans' do
    before(:each) do
      allow(FrilansFinansAPI::Terms).to(receive(:get).and_return('watman'))
    end

    it 'creates Frilans Finans terms' do
      expect do
        described_class.create_frilans_finans
      end.to change(FrilansFinansTerm, :count).by(2)
    end

    it 'creates terms agreements' do
      expect do
        described_class.create_frilans_finans
      end.to change(TermsAgreement, :count).by(2)
    end
  end
end
