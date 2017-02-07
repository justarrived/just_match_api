# frozen_string_literal: true
ActiveAdmin.register JobRequest do
  menu priority: 10

  batch_action :draft_sent, confirm: I18n.t('admin.batch_action_confirm') do |ids|
    collection.where(id: ids).map { |u| u.update(draft_sent: true) }

    redirect_to collection_path, notice: I18n.t('admin.job_request.batch.draft_sent')
  end

  batch_action :signed_by_customer, confirm: I18n.t('admin.batch_action_confirm') do |ids|
    collection.where(id: ids).map { |u| u.update(signed_by_customer: true) }

    redirect_to collection_path, notice: I18n.t('admin.job_request.batch.signed_by_customer') # rubocop:disable Metrics/LineLength
  end

  batch_action :cancelled, confirm: I18n.t('admin.batch_action_confirm') do |ids|
    collection.where(id: ids).map { |u| u.update(cancelled: true) }

    redirect_to collection_path, notice: I18n.t('admin.job_request.batch.cancelled')
  end

  batch_action :finished, confirm: I18n.t('admin.batch_action_confirm') do |ids|
    collection.where(id: ids).map { |u| u.update(finished: true) }

    redirect_to collection_path, notice: I18n.t('admin.job_request.batch.finished')
  end

  member_action :clone, method: :get do
    base_job = JobRequest.find(params[:id])
    @job_request = base_job.dup

    render :new, layout: false
  end

  action_item :clone, only: :show do
    path = clone_admin_job_request_path(id: job_request.id)
    link_to(I18n.t('admin.job_request.clone'), path)
  end

  scope :all, default: true
  scope :pending
  scope :finished
  scope :last_30_days

  filter :company_name
  filter :created_at
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
    column :status, &:current_status_name
    column :company_name
    column :responsible
    column :requirements
    column :language_requirements
    column :job_at_date
    column :created_at

    actions
  end

  show do |job_request|
    attributes_table do
      row :short_name
      row :responsible
      row :company_name
      row :company_org_no
      row :company_phone
      row :contact_person
      row :company_address
      row :company_email
      row :job_specification
      row :requirements
      row :hourly_pay
      row :job_scope
      row :job_at_date
      row :language_requirements
      row :requirements
      row :suitable_candidates
      row :comment
      row :draft_sent
      row :signed_by_customer
      row :cancelled
      row :finished
      row :created_at { datetime_ago_in_words(job_request.created_at) }
    end

    panel('Copy-pasta') do
      company_detail = lambda do |field, fallback|
        if field.blank?
          fallback.blank? ? '-' : fallback
        else
          field
        end
      end

      company = job_request.company
      company_email = company_detail.call(job_request.company_email, company&.email)
      company_name = company_detail.call(job_request.company_name, company&.name)
      company_org_no = company_detail.call(job_request.company_org_no, company&.cin)
      company_phone = company_detail.call(job_request.company_phone, company&.phone)
      contact_person = company_detail.call(job_request.contact_string, company&.users&.first&.name) # rubocop:disable Metrics/LineLength
      company_address = company_detail.call(job_request.company_address, company&.address)

      div do
        div do
          simple_format [
            %w(Org-nummer Telefon),
            [company_org_no, company_phone],
            %w(Företagsnamn Kontaktperson),
            [company_name, contact_person],
            %w(Företagsadress Epost),
            [company_address, company_email],
            ['Jobbspecifikation'],
            [job_request.job_specification],
            %w(Krav),
            [job_request.requirements],
            %w(Pris Omfattning Datum),
            [job_request.hourly_pay, job_request.job_scope, job_request.job_at_date]
          ].map { |row| row.join("\t") }.join("\n")
        end
      end

      active_admin_comments
    end
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
      f.input :contact_string, hint: 'Contact person name'
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
      :created_at,
      :updated_at,
      :short_name,
      :finished,
      :cancelled,
      :draft_sent,
      :signed_by_customer,
      :requirements,
      :hourly_pay,
      :company_org_no,
      :company_email,
      :company_phone,
      :company_id,
      :company_address
    ]
  end

  controller do
    def update(*_args)
      super do |_format|
        if resource.valid?
          redirect_to collection_url
          return
        end
      end
    end
  end
end
