# frozen_string_literal: true

ActiveAdmin.register TermsAgreement do
  menu parent: 'Misc'

  actions :index, :show

  batch_action :destroy, false
end
