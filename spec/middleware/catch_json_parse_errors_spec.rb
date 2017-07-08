# frozen_string_literal: true

RSpec.describe CatchJsonParseErrors do
  describe '#call' do
    it 'calls app when no error is raised' do
      app = ->(env) { env }
      middleware = described_class.new(app)
      expect(middleware.call(wat: :man)).to eq(wat: :man)
    end

    it 'returns rack error if ActionDispatch::Http::Parameters::ParseError is raised' do
      app = lambda { |_env|
        # We need to raise, rescue and then raise again since
        # ActionDispatch::Http::Parameters::ParseError expects
        # there to be a previous error
        begin
          raise StandardError
        rescue StandardError
          raise ActionDispatch::Http::Parameters::ParseError
        end
      }
      middleware = described_class.new(app)
      allow(middleware).to receive(:json_content_type?).and_return(true)

      http_status, headers, response = middleware.call(wat: :man)

      expect(http_status).to eq(400)
      expect(headers).to eq('Content-Type' => 'application/vnd.api+json')
      expect(response.first).to include('400')
    end
  end
end
