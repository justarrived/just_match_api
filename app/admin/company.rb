# frozen_string_literal: true
ActiveAdmin.register Company do
  permit_params do
    [
      :name,
      :cin,
      :created_at,
      :updated_at,
      :frilans_finans_id,
      :website,
      :email,
      :street,
      :zip,
      :city,
      :phone
    ]
  end
end
