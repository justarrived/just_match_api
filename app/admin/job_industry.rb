# frozen_string_literal: true

ActiveAdmin.register JobIndustry do
  permit_params do
    %i(job_id industry_id importance years_of_experience)
  end
end
