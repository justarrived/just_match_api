# frozen_string_literal: true

ActiveAdmin.register TermsAgreementConsent do
  menu parent: 'Misc'

  actions :index, :show

  batch_action :destroy, false
end
