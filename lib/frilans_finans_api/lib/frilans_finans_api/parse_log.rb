# frozen_string_literal: true
module FrilansFinansApi
  module ParseLog
    class LogRequest
      attr_reader :uri, :params, :body, :status

      def initialize(uri:, params:, body:, status:)
        @uri = uri
        @params = params
        @body = body
        @status = status
      end

      def access_token_request?
        uri.include?('auth/accesstoken')
      end

      def inspect
        parts = [
          "status: #{status}",
          "uri: #{uri}",
          "params: #{params}",
          "body: #{body}"
        ].join(', ')
        "#<#{self.class.name} #{parts}"
      end
    end

    def self.call(filename)
      lines = []
      File.foreach(filename) do |log_line|
        next unless log_line.index('[FrilansFinansApi::Request]')

        # MATCH BODY
        body_match = 'BODY: '
        body_match_index = log_line.index(body_match)
        body_content_index = body_match_index + body_match.length
        body_json = log_line[body_content_index..-1].strip
        body = JSON.parse(body_json)

        # MATCH STATUS
        status = string_between_markers(log_line, ' STATUS: ', ' BODY: ')

        # MATCH PARAM
        json_string = string_between_markers(log_line, ' PARAMS: ', ' STATUS: ')
        params = JSON.parse(json_string)

        # MATCH URI
        uri = string_between_markers(log_line, ' URI: ', ' PARAMS: ')

        lines << LogRequest.new(uri: uri, params: params, body: body, status: status)
      end
      lines
    end

    def self.string_between_markers(string, start_marker, end_marker)
      string[/#{Regexp.escape(start_marker)}(.*?)#{Regexp.escape(end_marker)}/m, 1]
    end
  end
end
