# frozen_string_literal: true

RSpec.describe CatchUnknownFormatErrors do
  describe '#call' do
    it 'calls app when no error is raised' do
      app = ->(env) { env }
      middleware = described_class.new(app)
      expect(middleware.call(wat: :man)).to eq(wat: :man)
    end

    it 'returns rack error ActionController::UnknownFormat error is raised' do
      app = ->(_env) { raise ActionController::UnknownFormat }
      middleware = described_class.new(app)

      http_status, headers, response = middleware.call(wat: :man)

      expect(http_status).to eq(406)
      expect(headers).to eq('Content-Type' => 'application/vnd.api+json')
      expect(response.first).to include('406')
    end
  end
end
