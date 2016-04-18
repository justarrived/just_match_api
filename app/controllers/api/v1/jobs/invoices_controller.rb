# frozen_string_literal: true
module Api
  module V1
    module Jobs
      class InvoicesController < BaseController
        after_action :verify_authorized, except: %i(create)

        resource_description do
          resource_id 'invoices'
          short 'API for managing invoices'
          name 'Invoices'
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
        example Doxxer.read_example(Invoice, method: :create)
        def create
          job_user = JobUser.find(params[:job_user_id])
          authorize_create(job_user)

          @invoice = CreateInvoiceService.create(
            job_user: job_user,
            frilans_finans_attributes: frilans_finans_attributes
          )
          if @invoice.valid?
            api_render(@invoice, status: :created)
          else
            respond_with_errors(@invoice)
          end
        end

        private

        def frilans_finans_attributes
          {}
        end

        def authorize_create(job_user)
          raise Pundit::NotAuthorizedError unless current_user == job_user.job.owner
        end
      end
    end
  end
end
