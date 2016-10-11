# frozen_string_literal: true
ActiveAdmin.register Rating do
  permit_params do
    [
      :from_user_id,
      :to_user_id,
      :job_id,
      :score
    ]
  end
end
