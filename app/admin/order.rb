# frozen_string_literal: true

ActiveAdmin.register Order do
  menu parent: 'Sales'

  filter :job_request_sales_user_id, as: :select, collection: -> { User.sales_users }
  filter :job_request_delivery_user_id, as: :select, collection: -> { User.delivery_users } # rubocop:disable Metrics/LineLength
  filter :category
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
    para 'Total unfilled & unlost revenue:'
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
    column :job_request
    column :total_revenue
    column :total_filled_revenue

    column :lost

    column :updated_at
  end

  show do |order|
    attributes_table do
      row :job_request
      row :name
      row :jobs do
        safe_join(
          order.jobs.order(filled: :asc).map do |job|
            title = "#{job.display_name} (#{job.filled ? 'filled' : 'unfilled'})"
            link_to(title, admin_job_path(job))
          end,
          ', '
        )
      end
      row :documents do
        safe_join(
          order.documents.order(created_at: :desc).map do |document|
            download_link_to(url: document.url, file_name: document.document_file_name)
          end,
          ', '
        )
      end
      row :total_revenue
      row :invoice_hourly_pay_rate
      row :hourly_pay_rate
      row :hours
      row :category
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
      f.input :name

      f.input :invoice_hourly_pay_rate
      f.input :hourly_pay_rate
      f.input :hours

      f.input :category

      if f.object.persisted?
        f.input :filled_invoice_hourly_pay_rate
        f.input :filled_hourly_pay_rate
        f.input :filled_hours
      end

      f.input :lost

      if f.object.persisted?
        f.has_many :order_documents, new_record: true do |ff|
          ff.semantic_errors(*ff.object.errors.keys)

          ff.inputs('Documents', for: [:document, ff.object.document || Document.new]) do |fff| # rubocop:disable Metrics/LineLength
            fff.input :document, required: true, as: :file
          end
        end
      else
        para strong(I18n.t('admin.order.persisted_before_document_upload'))
      end
    end

    f.actions
  end

  permit_params do
    [
      :invoice_hourly_pay_rate,
      :hours,
      :lost,
      :job_request_id,
      :hourly_pay_rate,
      :filled_invoice_hourly_pay_rate,
      :filled_hourly_pay_rate,
      :filled_hours,
      order_documents_attributes: [:name, { document_attributes: %i(id document) }]
    ]
  end

  controller do
    def scoped_collection
      super.includes(:jobs)
    end

    def update_resource(order, params_array)
      order_params = params_array.first
      order_documents_attrs = order_params.delete(:order_documents_attributes) || {}
      SetOrderDocumentsService.call(
        order: order,
        order_documents_param: order_documents_attrs&.to_unsafe_h
      )
      super
    end
  end
end
