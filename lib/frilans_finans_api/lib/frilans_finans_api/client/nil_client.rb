# frozen_string_literal: true
module FrilansFinansApi
  class NilClient
    HTTP_STATUS = 200
    NIL_URI = URI('http://example.com')

    Request = Struct.new(:uri)
    Response = Struct.new(:code, :body, :request)

    def currencies(**_args)
      body = '{}'
      request = Request.new(NIL_URI)
      Response.new(HTTP_STATUS, body, request)
    end

    alias_method :professions, :currencies
    alias_method :salaries, :currencies
    alias_method :taxes, :currencies
    alias_method :invoice, :currencies
    alias_method :user, :currencies
    alias_method :create_user, :currencies
    alias_method :create_company, :currencies
    alias_method :create_invoice, :currencies
    alias_method :update_invoice, :currencies
    alias_method :update_user, :currencies
  end
end
