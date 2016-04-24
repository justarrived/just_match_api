# frozen_string_literal: true
module FrilansFinansApiTest
  def isolate_frilans_finans_client(klass)
    before_klass = FrilansFinansApi.client_klass
    FrilansFinansApi.client_klass = klass
    result = yield(before_klass)
    FrilansFinansApi.client_klass = before_klass
    result
  end
end
