ActiveAdmin.register JobRequest do
  permit_params do
    [
      :company_name,
      :contact_string,
      :assignment,
      :job_scope,
      :job_specification,
      :language_requirements,
      :job_at_date,
      :responsible,
      :suitable_candidates,
      :comment,
      :finished
    ]
  end
end
