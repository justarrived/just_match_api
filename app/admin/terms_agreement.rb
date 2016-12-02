# frozen_string_literal: true
ActiveAdmin.register TermsAgreement do
  menu parent: 'Misc'

  batch_action :destroy, false
end
