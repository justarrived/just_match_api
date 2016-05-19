# frozen_string_literal: true
class AddFrilansFinansTermToTermsAgreements < ActiveRecord::Migration
  def change
    add_reference :terms_agreements, :frilans_finans_term, index: true, foreign_key: true
  end
end
