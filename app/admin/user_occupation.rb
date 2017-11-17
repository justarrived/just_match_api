# frozen_string_literal: true

ActiveAdmin.register UserOccupation do
  menu parent: 'Users'

  permit_params do
    %i(user_id occupation_id importance years_of_experience)
  end
end
