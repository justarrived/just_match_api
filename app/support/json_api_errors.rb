# frozen_string_literal: true
class JsonApiErrors
  def initialize
    @errors = []
  end

  def add(**args)
    @errors << JsonApiError.new(**args)
  end

  # Rails is awkard and calls #to_json with a context argument
  def to_json(_context = nil)
    { errors: @errors }.to_json
  end
end
