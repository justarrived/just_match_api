require 'csv'
require 'wintrgarden_exporter/base_exporter'

module Wintrgarden
  class UserComments < BaseExporter
    # TODO
    def to_csv
      fail NotImplementedError
    end

    # TODO
    def to_row(model)
      []
    end
  end
end
