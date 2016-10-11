# frozen_string_literal: true
ActiveAdmin.register FrilansFinansInvoice do
  permit_params do
    [:activated]
  end
end
