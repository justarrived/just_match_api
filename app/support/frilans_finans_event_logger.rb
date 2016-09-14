# frozen_string_literal: true
class FrilansFinansEventLogger
  def request_event(params:, status:, verb:, uri:, body:)
    FrilansFinansApiLog.create!(
      verb: verb,
      params: params,
      status: status,
      uri: uri,
      response_body: body
    )
  end
end
