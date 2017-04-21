# frozen_string_literal: true

ActiveAdmin.register Order do
  menu parent: 'Sales'

  filter :job_request_sales_user_id, as: :select, collection: -> { User.sales_users }
  filter :job_request_delivery_user_id, as: :select, collection: -> { User.delivery_users } # rubocop:disable Metrics/LineLength
  filter :invoice_hourly_pay_rate
  filter :hourly_pay_rate
  filter :hours
  filter :filled_invoice_hourly_pay_rate
  filter :filled_hourly_pay_rate
  filter :filled_hours
  filter :created_at
  filter :updated_at

  scope :all
  scope :unfilled, default: true

  action_item :create_job, only: :show do
    path = create_job_with_order_admin_job_path(order_id: order.id)
    link_to(I18n.t('admin.order.create_job'), path)
  end

  member_action :create_order_with_job_request, method: :get do
    @order = Order.new(job_request_id: params[:job_request_id])

    render :new, layout: false
  end

  index do
    selectable_column

    column :order { |order| link_to(order.display_name, admin_order_path(order)) }
    column :job_request
    column :total_revenue
    column :total_filled_revenue

    column :lost

    column :updated_at
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
      row :total_revenue
      row :invoice_hourly_pay_rate
      row :hourly_pay_rate
      row :hours
      row :total_filled_revenue
      row :filled_invoice_hourly_pay_rate
      row :filled_hourly_pay_rate
      row :filled_hours

      row :lost
      row :created_at
      row :updated_at
    end

    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :job_request

      f.input :invoice_hourly_pay_rate
      f.input :hourly_pay_rate
      f.input :hours

      if f.object.persisted?
        f.input :filled_invoice_hourly_pay_rate
        f.input :filled_hourly_pay_rate
        f.input :filled_hours
      end

      f.input :lost
    end

    f.actions
  end

  permit_params do
    %i(invoice_hourly_pay_rate hours lost job_request_id hourly_pay_rate)
  end

  controller do
    def scoped_collection
      super.includes(:jobs)
    end
  end
end
