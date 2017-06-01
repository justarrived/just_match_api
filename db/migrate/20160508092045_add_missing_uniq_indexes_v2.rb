# frozen_string_literal: true

class AddMissingUniqIndexesV2 < ActiveRecord::Migration
  def change
    add_index :currencies, :frilans_finans_id, unique: true

    add_index :invoices, :job_user_id, unique: true, name: 'index_invoices_on_job_user_id_uniq' # rubocop:disable Metrics/LineLength

    add_index :terms_agreements, :version, unique: true

    add_index :terms_agreement_consents, %i(user_id job_id), unique: true
    add_index :terms_agreement_consents, %i(job_id user_id), unique: true
  end
end
