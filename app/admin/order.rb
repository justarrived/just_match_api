# frozen_string_literal: true

ActiveAdmin.register Order do
  menu parent: 'Sales'

  filter :job_request_sales_user_id, as: :select, collection: -> { User.sales_users }
  filter :job_request_delivery_user_id, as: :select, collection: -> { User.delivery_users } # rubocop:disable Metrics/LineLength
  filter :category, as: :select, collection: -> { Order::CATEGORIES.to_a }
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

  sidebar :totals, only: :index do
    para I18n.t('admin.order.sold_revenue_to_fill')
    strong NumberFormatter.new.to_unit(
      Order.unfilled.total_revenue,
      'SEK',
      locale: :sv
    )
  end

  action_item :create_job, only: :show do
    path = create_job_with_order_admin_job_path(order_id: order.id)
    link_to(I18n.t('admin.order.create_job'), path)
  end

  member_action :create_order_with_job_request, method: :get do
    job_request = JobRequest.find_by(id: params[:job_request_id])
    @order = Order.new(job_request_id: job_request&.id)
    @order.name = job_request&.short_name

    render :new, layout: false
  end

  index do
    selectable_column

    column :order { |order| link_to(order.display_name, admin_order_path(order)) }
    column :total do |order|
      total_filled_over_sold_order_value(order.current_order_value)
    end
    column :total_filled_revenue

    column :lost

    column :updated_at
  end

  show do |order|
    locals = { order: order }
    render partial: 'admin/orders/show', locals: locals
  end

  form do |f|
    render partial: 'admin/orders/form', locals: { f: f }
  end

  permit_params do
    [
      :name,
      :invoice_hourly_pay_rate,
      :category,
      :hours,
      :lost,
      :job_request_id,
      :hourly_pay_rate,
      :filled_invoice_hourly_pay_rate,
      :filled_hourly_pay_rate,
      :filled_hours,
      order_documents_attributes: [:name, { document_attributes: %i(id document) }],
      order_values_attributes: %i(
        id
        order_id
        previous_order_value_id
        change_comment
        change_reason_category
        total_sold
        sold_hourly_salary
        sold_hourly_price
        sold_hours_per_month
        sold_number_of_months
        total_filled
        filled_hourly_salary
        filled_hourly_price
        filled_hours_per_month
        filled_number_of_months
      )
    ]
  end

  controller do
    def scoped_collection
      super.includes(:jobs)
    end

    def update_resource(order, params_array)
      order_params = params_array.first
      order_documents_attrs = order_params.delete(:order_documents_attributes)&.to_unsafe_h || {} # rubocop:disable Metrics/LineLength
      SetOrderDocumentsService.call(
        order: order,
        order_documents_param: order_documents_attrs
      )
      super
    end
  end
end
