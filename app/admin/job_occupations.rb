# frozen_string_literal: true

ActiveAdmin.register JobOccupation do
  menu parent: 'Jobs'

  permit_params do
    %i(job_id occupation_id importance years_of_experience)
  end
end
