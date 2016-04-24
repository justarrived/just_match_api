# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Sweepers::InvoiceSweeper do
  describe '#create_frilans_finans' do
    it 'calls CreateFrilansFinansInvoiceService for the right invoices' do
      FactoryGirl.create(:invoice, frilans_finans_id: nil)
      FactoryGirl.create(:invoice, frilans_finans_id: nil)
      FactoryGirl.create(:invoice, frilans_finans_id: 1337)
      allow(CreateFrilansFinansInvoiceService).to receive(:create)
      described_class.create_frilans_finans
      expect(CreateFrilansFinansInvoiceService).to have_received(:create).twice
    end
  end
end
