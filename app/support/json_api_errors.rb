# frozen_string_literal: true
class JsonApiErrors
  include Enumerable

  def initialize
    @errors = []
  end

  def add(**args)
    @errors << JsonApiError.new(**args)
  end

  def each(&block)
    @errors.each(&block)
  end

  def length
    @errors.length
  end
  alias_method :size, :length

  def to_h
    { errors: @errors.map(&:to_h) }
  end

  # Rails is awkward and calls #to_json with a context argument
  def to_json(_context = nil)
    to_h.to_json
  end
end
