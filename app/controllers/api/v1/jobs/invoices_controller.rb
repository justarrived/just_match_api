# frozen_string_literal: true
module Api
  module V1
    module Jobs
      class InvoicesController < BaseController
        after_action :verify_authorized, except: %i(create)

        resource_description do
          resource_id 'invoices'
          short 'API for managing invoices'
          name 'Invoice'
          description '
            Here you can find the documentation for inteteracting with invoices.
          '
          formats [:json]
          api_versions '1.0'
        end

        api :POST, '/jobs/:job_id/users/:job_user_id/invoices', 'Create new invoice.'
        description 'Creates and returns new rating.'
        error code: 400, desc: 'Bad request'
        error code: 404, desc: 'Not found'
        error code: 422, desc: 'Unprocessable entity'
        example '{}'
        def create
          job_user = JobUser.find(params[:id])
          authorize_create(job_user)

          @invoice = FrilansFinansInvoiceService.create(job_user: job_user)
          if @invoice.valid?
            InvoiceCreatedNotifier.call(
              job: job_user.job,
              user: job_user.user
            )
            render json: {}, status: :created
          else
            respond_with_errors(@invoice)
          end
        end

        private

        def authorize_create(job_user)
          raise Pundit::NotAuthorizedError unless current_user == job_user.job.owner
        end
      end
    end
  end
end
