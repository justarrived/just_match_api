# frozen_string_literal: true
ActiveAdmin.register TermsAgreementConsent do
  menu parent: 'Misc'

  batch_action :destroy, false
end
