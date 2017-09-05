# frozen_string_literal: true

ActiveAdmin.register Address do
  menu parent: 'Misc'

  permit_params do
    %i[
      street1
      street2
      city
      state
      postal_code
      municipality
      country_code
      latitude
      longitude
    ]
  end
end
