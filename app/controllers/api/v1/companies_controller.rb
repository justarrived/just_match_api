# frozen_string_literal: true
module Api
  module V1
    class CompaniesController < BaseController
      before_action :set_company, only: [:show]

      resource_description do
        short 'API for Companies'
        name 'Companies'
        description ''
        formats [:json]
        api_versions '1.0'
      end

      ALLOWED_INCLUDES = %w(company_images).freeze

      api :GET, '/companies', 'List companies'
      description 'Returns a list of companies.'
      ApipieDocHelper.params(self, Index::CompaniesIndex)
      example Doxxer.read_example(Company, plural: true)
      def index
        authorize(Company)

        companies_index = Index::CompaniesIndex.new(self)
        @companies = companies_index.companies(Company.includes(:company_images))

        api_render(@companies, total: companies_index.count)
      end

      api :GET, '/companies/:id/', 'Show company'
      description 'Returns a company.'
      error code: 404, desc: 'Not found'
      ApipieDocHelper.params(self)
      example Doxxer.read_example(Company)
      def show
        authorize(@company)

        api_render(@company)
      end

      api :POST, '/companies/', 'Create company'
      description 'Creates and returns a company.'
      error code: 422, desc: 'Unprocessable entity'
      param :data, Hash, desc: 'Top level key', required: true do
        param :attributes, Hash, desc: 'Company attributes', required: true do
          param :name, String, desc: 'Name of the company', required: true
          param :cin, String, desc: 'Swedish organisation number', required: true
          param :email, String, desc: 'Email', required: true
          param :phone, String, desc: 'Phone', required: true
          param :street, String, desc: 'Street address', required: true
          param :zip, String, desc: 'Zip code', required: true
          param :city, String, desc: 'City', required: true
          param :website, String, desc: 'Website URL'
          param :company_image_one_time_token, String, desc: 'Company image one time token' # rubocop:disable Metrics/LineLength
        end
      end
      example Doxxer.read_example(Company, method: :create)
      def create
        authorize(Company)

        @company = Company.new(company_params)

        if @company.valid?
          @company.logo_image_token = jsonapi_params[:company_image_one_time_token]
          @company.save!

          api_render(@company, status: :created)
        else
          api_render_errors(@company)
        end
      end

      private

      def company_params
        jsonapi_params.permit(:name, :cin, :website, :email, :phone, :street, :zip, :city)
      end

      def frilans_params
        jsonapi_params.permit(:name)
      end

      def set_company
        @company = Company.find(params[:company_id])
      end
    end
  end
end
