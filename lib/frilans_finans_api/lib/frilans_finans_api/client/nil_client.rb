# frozen_string_literal: true
module FrilansFinansApi
  class NilClient
    Response = Struct.new(:body)

    def currencies(**_args)
      Response.new('{}')
    end

    alias_method :professions, :currencies
    alias_method :taxes, :currencies
    alias_method :invoice, :currencies
    alias_method :create_user, :currencies
    alias_method :create_company, :currencies
    alias_method :create_invoice, :currencies
  end
end
