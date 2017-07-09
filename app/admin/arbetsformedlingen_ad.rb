# frozen_string_literal: true

ActiveAdmin.register ArbetsformedlingenAd do
  menu parent: 'Jobs'

  config.batch_actions = false

  index do
    selectable_column

    column :id do |ad|
      link_to(ad.id, admin_arbetsformedlingen_ad_path(ad))
    end
    column :published
    column :occupation
    column :job
    column :updated_at do |ad|
      link_to(datetime_ago_in_words(ad.updated_at), admin_arbetsformedlingen_ad_path(ad))
    end
  end

  show do
    logs = arbetsformedlingen_ad.arbetsformedlingen_ad_logs
    attributes_table do
      row :id
      row :job
      row :occupation
      row :published
      row :updated_at
      row :created_at
      row :logs_count { logs.count }
    end

    panel I18n.t('admin.arbetsformedlingen_ad_log.name') do
      logs.reverse_each do |log|
        h4 log.updated_at
        log.response['messages'].each do |message|
          para message['message']
          if message['error_code']
            em I18n.t(
              'admin.arbetsformedlingen_ad_log.af_error_code_msg',
              code: message['error_code']
            )
          else
            em I18n.t('admin.arbetsformedlingen_ad_log.af_valid_msg')
          end
          hr
        end
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs(f.object.display_name) do
      f.input :job, collection: Job.with_translations
      f.input :occupation, collection: Arbetsformedlingen::OccupationCode.to_form_array(name_only: true) # rubocop:disable Metrics/LineLength
      f.input :published
    end

    f.actions
  end

  member_action :create_with_job, method: :get do
    @arbetsformedlingen_ad = ArbetsformedlingenAd.new(job_id: params[:job_id])

    render :new, layout: false
  end

  member_action :push_to_arbetsformedlingen, method: :post do
    ad = resource

    result = I18n.with_locale(:sv) { PushArbetsformedlingenAdService.call(ad) }

    if result.errors.empty?
      message = I18n.t('admin.arbetsformedlingen_ad.push.pushing_msg')
      redirect_to admin_arbetsformedlingen_ad_path(ad), notice: message
    else
      ad.validate_job_data_for_arbetsformedlingen
      message = I18n.t(
        'admin.arbetsformedlingen_ad.push.validation_error_msg',
        errors: ad.errors.full_messages.join(', ')
      )
      redirect_to admin_arbetsformedlingen_ad_path(ad), alert: message
    end
  end

  action_item :push_to_arbetsformedlingen, only: :show do
    link_to(
      I18n.t('admin.arbetsformedlingen_ad.push.button'),
      push_to_arbetsformedlingen_admin_arbetsformedlingen_ad_path(id: resource.id),
      method: :post
    )
  end

  permit_params do
    %i(job_id published occupation)
  end
end
