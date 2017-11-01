# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sweepers::FrilansFinansInvoiceSweeper do
  describe '#create_frilans_finans' do
    it 'calls CreateFrilansFinansInvoiceService for the right invoices' do
      FactoryBot.create(:frilans_finans_invoice, frilans_finans_id: nil)
      FactoryBot.create(:frilans_finans_invoice, frilans_finans_id: nil)
      FactoryBot.create(:frilans_finans_invoice, frilans_finans_id: 1337)
      allow(CreateFrilansFinansInvoiceService).to receive(:create)
      described_class.create_frilans_finans
      expect(CreateFrilansFinansInvoiceService).to have_received(:create).twice
    end
  end

  describe '#activate_frilans_finans' do
    let(:passed_job) { FactoryBot.create(:passed_job) }
    let(:job_user) { FactoryBot.create(:job_user_passed_job) }
    let(:job_user_with_invoice) do
      FactoryBot.create(
        :job_user_will_perform,
        job: passed_job
      )
    end
    let(:frilans_finans_id) { 1 }
    let(:ff_invoice) do
      FactoryBot.create(
        :frilans_finans_invoice,
        job_user: job_user_with_invoice,
        frilans_finans_id: frilans_finans_id
      )
    end

    it 'activates all Frilans Finans invoices that need activation' do
      job_user_with_invoice.invoice = FactoryBot.create(
        :invoice,
        job_user: job_user_with_invoice,
        frilans_finans_invoice: ff_invoice
      )
      job_user_with_invoice.save!

      isolate_frilans_finans_client(FrilansFinansAPI::FixtureClient) do
        described_class.activate_frilans_finans
      end

      # Records needs to be reloaded manually, since otherwise they wont
      # match whats in the database..
      ff_invoice_not_activated = job_user.frilans_finans_invoice.reload
      ff_invoice_activated = job_user_with_invoice.
                             frilans_finans_invoice.reload

      expect(ff_invoice_not_activated.activated).to eq(false)
      expect(ff_invoice_activated.activated).to eq(true)
    end

    context 'failed Frilans Finans id match' do
      let(:frilans_finans_id) { 123 }

      it 'sends notifiation' do
        job_user_with_invoice.invoice = FactoryBot.create(
          :invoice,
          job_user: job_user_with_invoice,
          frilans_finans_invoice: ff_invoice
        )
        job_user_with_invoice.save!

        allow(FailedToActivateInvoiceNotifier).to receive(:call).
          with(ff_invoice: ff_invoice)

        isolate_frilans_finans_client(FrilansFinansAPI::FixtureClient) do
          described_class.activate_frilans_finans
        end

        expect(FailedToActivateInvoiceNotifier).to have_received(:call)
      end
    end
  end
end
