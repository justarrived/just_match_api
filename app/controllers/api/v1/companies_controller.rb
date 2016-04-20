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

      api :GET, '/companies', 'List companies'
      description 'Returns a list of companies.'
      ApipieDocHelper.params(self, Index::CompaniesIndex)
      example Doxxer.read_example(Company, plural: true)
      def index
        authorize(Company)

        companies_index = Index::CompaniesIndex.new(self)
        @companies = companies_index.companies

        api_render(@companies, total: companies_index.count)
      end

      api :GET, '/companies/:id/', 'Show company'
      description 'Returns a company.'
      error code: 404, desc: 'Not found'
      ApipieDocHelper.params(self)
      example Doxxer.read_example(Company)
      def show
        authorize(Company)

        api_render(@company)
      end

      api :POST, '/companies/', 'Create company'
      description 'Creates and returns a company.'
      error code: 422, desc: 'Unprocessable entity'
      param :data, Hash, desc: 'Top level key', required: true do
        param :attributes, Hash, desc: 'Company attributes', required: true do
          param :name, String, desc: 'Name of the company', required: true
          param :cin, String, desc: 'Swedish organisation number', required: true
          param :website, String, desc: 'Website URL'
        end
      end
      example Doxxer.read_example(Company)
      def create
        authorize(Company)

        @company = Company.new(company_params)

        if @company.valid?
          ff_company = FrilansFinansApi::Company.create(attributes: frilans_params)
          @company.frilans_finans_id = ff_company.resource.id
          @company.save!

          api_render(@company, status: :created)
        else
          respond_with_errors(@company)
        end
      end

      private

      def company_params
        jsonapi_params.permit(:name, :cin, :website)
      end

      def frilans_params
        jsonapi_params.permit(:name)
      end

      def set_company
        @company = Company.find(params[:id])
      end
    end
  end
end
