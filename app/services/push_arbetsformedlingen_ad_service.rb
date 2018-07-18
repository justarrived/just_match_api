# frozen_string_literal: true

class PushArbetsformedlingenAdService
  Result = Struct.new(:errors, :log, keyword_init: true)

  def self.call(arbetsformedlingen_ad)
    unless AppConfig.arbetsformedlingen_active?
      warn 'PushArbetsformedlingenAdService was called but integration is not configured to be active' # rubocop:disable Metrics/LineLength
      return Result.new(errors: [])
    end

    ad = arbetsformedlingen_ad

    staffing_company = Company.default_staffing_company
    wrapper = Arbetsformedlingen::JobWrapper.new(ad, staffing_company: staffing_company)
    return Result.new(errors: wrapper.errors) unless wrapper.valid?

    client = Arbetsformedlingen::API::Client.new
    response = client.create_ad(wrapper.packet)

    log = ArbetsformedlingenAdLog.create!(
      arbetsformedlingen_ad: ad,
      response: {
        code: response.code,
        messages: response.messages,
        body: response.body,
        request_body: response.request_body
      }
    )

    Result.new(errors: [], log: log)
  end
end
