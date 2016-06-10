# frozen_string_literal: true
class JsonApiError
  def initialize(status:, detail:, pointer: nil)
    @status = status
    @detail = detail
    self.pointer = pointer
  end

  def to_json
    response = { status: @status, detail: @detail }
    response[:source] = { pointer: @pointer } unless @pointer.nil?

    response.to_json
  end

  private

  def pointer=(pointer)
    return if pointer.nil?

    @pointer = "/data/attributes/#{pointer}"
  end
end
