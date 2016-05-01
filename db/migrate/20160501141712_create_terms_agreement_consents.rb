# frozen_string_literal: true
class CreateTermsAgreementConsents < ActiveRecord::Migration
  def change
    create_table :terms_agreement_consents do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :job, index: true, foreign_key: true
      t.belongs_to :terms_agreement, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
