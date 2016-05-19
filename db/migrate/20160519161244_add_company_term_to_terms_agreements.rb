# frozen_string_literal: true
class AddCompanyTermToTermsAgreements < ActiveRecord::Migration
  def change
    add_column :terms_agreements, :company_term, :boolean, default: false
  end
end
