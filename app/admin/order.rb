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
    column :total_sold
    column :total_filled_revenue

    column :lost

    column :updated_at
  end

  show do |order|
    current_order_value = order.order_values.last

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

      row :total_filled_over_sold_order_value do
        total_filled_over_sold_order_value(current_order_value)
      end

      row :category
      row :lost
      row :created_at
      row :updated_at
    end

    order.order_values.each do |order_value|
      panel order_value.display_name do
        attributes_table_for(order_value) do
          row :order_value do
            link_to(order_value.display_name, admin_order_value_path(order_value))
          end
          row :previous_order_value
          row :total_filled_over_sold_order_value do
            total_filled_over_sold_order_value(current_order_value)
          end
          row :total_sold_value_change
          row :total_filled_value_change

          if order_value.total_sold
            row :total_sold
            row :total_filled
          else
            row :sold_hourly_salary
            row :sold_hourly_price
            row :sold_hours_per_month
            row :sold_number_of_months

            row :filled_hourly_salary
            row :filled_hourly_price
            row :filled_hours_per_month
            row :filled_number_of_months
          end

          row :change_comment
          row :change_reason_category
        end
      end
    end

    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.semantic_errors(*f.object.errors.keys)

      f.input :job_request
      f.input :name
      f.input :hours

      f.input :category

      current_order_value = f.object.current_order_value
      if f.object.persisted?
        f.input :lost

        f.has_many :order_values, new_record: true do |ff|
          # rubocop:disable Metrics/LineLength
          if ff.object.new_record?
            ff.semantic_errors(*ff.object.errors.keys)

            ff.input :change_comment, label: 'Comment'
            ff.input :change_reason_category if f.object.order_values.any?

            ff.input :previous_order_value_id, as: :hidden, input_html: { value: current_order_value&.id }

            current_total_sold = current_order_value&.total_sold
            ff.input :total_sold, input_html: { value: current_total_sold }
            ff.input :total_filled, input_html: { value: current_order_value&.total_filled || 0 }

            if current_total_sold.nil?
              ff.input :sold_hourly_salary, input_html: { value: current_order_value&.sold_hourly_salary }
              ff.input :sold_hourly_price, input_html: { value: current_order_value&.sold_hourly_price }
              ff.input :sold_hours_per_month, input_html: { value: current_order_value&.sold_hours_per_month }
              ff.input :sold_number_of_months, input_html: { value: current_order_value&.sold_number_of_months }

              ff.input :filled_hourly_salary, input_html: { value: current_order_value&.filled_hourly_salary || 0 }
              ff.input :filled_hourly_price, input_html: { value: current_order_value&.filled_hourly_price || 0 }
              ff.input :filled_hours_per_month, input_html: { value: current_order_value&.filled_hours_per_month || 0 }
              ff.input :filled_number_of_months, input_html: { value: current_order_value&.filled_number_of_months || 0 }
            end
          end
        end
        # rubocop:enable Metrics/LineLength

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
