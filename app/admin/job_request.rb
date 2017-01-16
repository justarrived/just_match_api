# frozen_string_literal: true
ActiveAdmin.register JobRequest do
  menu parent: 'Misc'

  scope :all, default: true
  scope :pending
  scope :finished

  filter :company_name
  filter :contact_string
  filter :assignment
  filter :job_scope
  filter :job_specification
  filter :language_requirements
  filter :job_at_date
  filter :responsible
  filter :suitable_candidates
  filter :comment
  filter :finished

  index do
    selectable_column

    column :finished
    column :company_name
    column :responsible
    column :contact_string
    column :language_requirements
    column :job_at_date
    column :created_at

    actions
  end

  form do |f|
    f.semantic_errors

    # rubocop:disable Metrics/LineLength
    f.inputs 'Basic' do
      f.input :short_name, hint: 'For example "The IKEA-job"..'
      f.input :responsible, hint: 'Responsible person @ Sales department'
    end

    f.inputs 'Company details' do
      f.input :company, hint: 'You can leave this blank and instead fill in the below fields'
      f.input :company_name
      f.input :company_org_no, hint: 'Company organisation number'
      f.input :company_email, hint: 'Email for company contact person'
      f.input :company_phone, hint: 'Phone for company contact person'
    end

    f.inputs 'Job details' do
      f.input :job_specification, as: :text, hint: 'A more extensive description (if you have one) of the job'
      f.input :hourly_pay, hint: 'The hourly pay have you been discussing'
      f.input :job_at_date, hint: 'Estimated job dates, i.e "3 months starting in March-ish"'
      f.input :job_scope, hint: 'Full time? Part time? etc..'
      f.input :language_requirements, hint: 'The language level required to perform the job, i.e "Fluent", "Basic understanding" etc..'
      f.input :requirements, hint: 'The requirements in order to be able to perform the job'
      f.input :suitable_candidates, hint: 'General note about what candidates might be suitable' if job_request.persisted?
      f.input :comment, hint: 'Anything that might not have been said above'
    end

    if job_request.persisted?
      f.inputs 'Status flags' do
        f.input :draft_sent
        f.input :signed_by_customer
        f.input :cancelled
        f.input :finished
      end
    end
    # rubocop:enable Metrics/LineLength

    f.actions
  end

  permit_params do
    [
      :cancelled,
      :comment,
      :company_email,
      :company_name,
      :company_org_no,
      :company_phone,
      :company,
      :draft_sent,
      :finished,
      :hourly_pay,
      :job_at_date,
      :job_scope,
      :job_specification,
      :language_requirements,
      :requirements,
      :responsible,
      :short_name,
      :signed_by_customer,
      :suitable_candidates
    ]
  end
end
