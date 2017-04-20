# frozen_string_literal: true

ActiveAdmin.register Order do
  filter :job_request_sales_user_id, as: :select, collection: -> { User.sales_users }
  filter :job_request_delivery_user_id, as: :select, collection: -> { User.delivery_users } # rubocop:disable Metrics/LineLength
  filter :invoice_hourly_pay_rate
  filter :hourly_pay_rate
  filter :hours
  filter :created_at
  filter :updated_at

  scope :all
  scope :unfilled, default: true

  action_item :create_job, only: :show do
    path = create_job_with_order_admin_job_path(order_id: order.id)
    link_to(I18n.t('admin.order.create_job'), path)
  end

  member_action :create_order_with_job_request, method: :get do
    job_request_id = params[:job_request_id]

    @order = Order.find_by(job_request_id: job_request_id)
    if @order
      notice = I18n.t('admin.order.job_requested_already_created')
      redirect_to admin_order_path(@order), alert: notice
    else
      @order = Order.new(job_request_id: job_request_id)

      render :new, layout: false
    end
  end

  show do |order|
    attributes_table do
      row :job_request
      row :jobs do
        safe_join(
          order.jobs.order(filled: :asc).map do |job|
            title = "#{job.display_name} (#{job.filled ? 'filled' : 'unfilled'})"
            link_to(title, admin_job_path(job))
          end,
          ', '
        )
      end
      row :invoice_hourly_pay_rate
      row :hourly_pay_rate
      row :hours
      row :lost
      row :created_at
      row :updated_at
    end

    active_admin_comments
  end

  permit_params do
    %i(invoice_hourly_pay_rate hours lost job_request_id hourly_pay_rate)
  end
end
