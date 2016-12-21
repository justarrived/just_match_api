# frozen_string_literal: true
module SyncFFUserAccountDetailsService
  def self.call(user:)
    ff_user_params = {
      account_clearing_number: user.account_clearing_number,
      account_number: user.account_number
    }
    ff_id = user.frilans_finans_id
    FrilansFinansApi::User.update(id: ff_id, attributes: ff_user_params)
    user.frilans_finans_payment_details = true
    user.save!
  end
end
