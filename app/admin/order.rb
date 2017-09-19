# frozen_string_literal: true

ActiveAdmin.register Order do
  menu parent: 'Sales'

  filter :sales_user_id, as: :select, collection: -> { User.sales_users }
  filter :delivery_user_id, as: :select, collection: -> { User.delivery_users } # rubocop:disable Metrics/LineLength
  filter :category, as: :select, collection: -> { Order::CATEGORIES.to_a }
  filter :created_at
  filter :updated_at

  scope :all
  scope('Backlog', default: true, &:unfilled_and_unlost)
  scope('Filled', default: true, &:filled_and_unlost)
  scope :lost

  sidebar :totals, only: :index do
    para I18n.t('admin.order.current_scope_total_revenue')
    strong NumberFormatter.new.to_unit(
      orders.limit(nil).total_revenue,
      'SEK',
      locale: :sv
    )
    hr
    para I18n.t('admin.order.current_scope_total_unfilled_unlost_revenue')
    strong NumberFormatter.new.to_unit(
      orders.unfilled_and_unlost.limit(nil).total_revenue,
      'SEK',
      locale: :sv
    )
    hr
    para I18n.t('admin.order.total_unfilled_unlost_revenue')
    strong NumberFormatter.new.to_unit(
      Order.unfilled_and_unlost.total_revenue,
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
    @order.company = job_request&.company
    @order.sales_user = job_request&.sales_user
    @order.delivery_user = job_request&.delivery_user

    render :new, layout: false
  end

  member_action :create_order_extension, method: :get do
    previous_order = Order.find_by(id: params[:order_id])

    if previous_order
      @order = previous_order.dup
      @order.previous_order_id = previous_order.id
      @order.order_values = [previous_order.order_values.last]
      @order.save!
      render :edit, layout: false
    else
      @order = Order.new
      render :new, layout: false
    end
  end

  index do
    selectable_column

    column :order { |order| link_to(order.display_name, admin_order_path(order)) }
    column :total do |order|
      total_filled_over_sold_order_value(order.order_values.last)
    end

    column :lost
    column :company

    column :updated_at

    actions
  end

  show do |order|
    render partial: 'admin/orders/show', locals: { order: order }
  end

  form do |f|
    render partial: 'admin/orders/form', locals: { f: f }
  end

  permit_params do
    [
      :name,
      :category,
      :lost,
      :company_id,
      :job_request_id,
      :sales_user_id,
      :delivery_user_id,
      order_documents_attributes: [:name, { document_attributes: %i(id document) }],
      order_values_attributes: %i(
        id
        order_id
        previous_order_value_id
        changed_by_user_id
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
      super.includes(
        :company, :job_request, :jobs, :order_values, :sales_user, :delivery_user
      )
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
