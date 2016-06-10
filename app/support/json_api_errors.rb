class JsonApiErrors
  def initialize
    @errors = []
  end

  def add(**args)
    @errors << JsonApiError.new(**args)
  end

  def to_json(_context = nil)
    { errors: @errors }.to_json
  end
end
