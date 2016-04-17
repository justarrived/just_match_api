# frozen_string_literal: true
module Admin
  class CompaniesController < Admin::ApplicationController
    # See https://administrate-docs.herokuapp.com/customizing_controller_actions
    # for more information

    def create
      company = Company.new(company_attributes)

      if company.valid?
        attributes = frilans_attributes(company)
        ff_company = FrilansFinansApi::Company.create(attributes: attributes)
        company.frilans_finans_id = ff_company.resource.id
        company.save!

        render :show, locals: locals_for(:show, company)
      else
        render :edit, locals: locals_for(:form, company)
      end
    end

    private

    def company_attributes
      params.require(:company).permit(:name, :cin)
    end

    def frilans_attributes(company)
      params.require(:company).permit(
        :email, :street, :zip, :city, :country, :contact, :phone
      ).merge(name: company.name)
    end

    def locals_for(template, company)
      klass = "Administrate::Page::#{template.capitalize}".constantize
      { page: klass.new(CompanyDashboard.new, company) }
    end
  end
end
