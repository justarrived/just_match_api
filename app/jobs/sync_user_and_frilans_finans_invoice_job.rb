# frozen_string_literal: true

class SyncUserAndFrilansFinansInvoiceJob < ApplicationJob
  def perform(ff_invoice)
    user = ff_invoice.job_user.user
    # Create/sync the user with Frilans Finans
    unless user.frilans_finans_id
      remote_id = FindFrilansFinansUserIdService.call(email: user.email)
      if remote_id.present?
        user.frilans_finans_id = remote_id
        user.save!
      else
        SyncFrilansFinansUserService.call(user: user)
        user.reload
      end
    end

    # Create/sync the frilans_finans_invoice with Frilans Finans
    ff_invoice.reload
    unless ff_invoice.frilans_finans_id
      CreateFrilansFinansInvoiceService.create(ff_invoice: ff_invoice)
      ff_invoice.reload
    end

    SyncFrilansFinansInvoiceService.call(frilans_finans_invoice: ff_invoice)
  end
end
