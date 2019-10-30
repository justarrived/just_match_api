require 'active_support/core_ext'

module Wintrgarden
  class BaseExporter
    def initialize(datums)
      @datums = datums
    end

    def to_csv
      CSV.open("tmp/#{filename}", 'w') do |csv|
        csv << header
        @datums.find_in_batches(batch_size: batch_size) do |datums|
          datums.each { |data| csv << to_row(data) }
        end
      end
    end

    def to_row
      fail NotImplementedError, 'please implement!'
    end

    def filename
      klass_name = self.class.to_s.gsub(/Wintrgarden::/, '').underscore
      if klass_name == "base_exporter"
        raise "Illegal name #{klass_name}, please implement #filename method in your subclass"
      end

      "#{klass_name}.csv"
    end

    def batch_size
      500
    end

    def aws_production_url(url)
      base = 'https://just-match-production.s3.amazonaws.com'
      url.gsub(/localhost\//, base)
    end
  end
end
