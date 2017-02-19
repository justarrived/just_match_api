# frozen_string_literal: true
require 'set'
require 'honey_format'

require 'import/wgtrm/import_users'

module Wgtrm
  module Import
    def self.perform(ignore_emails: [], path: 'tmp/wgtrm-users.csv')
      csv_string = File.read(path)
      csv = HoneyFormat::CSV.new(csv_string, delimiter: ';')

      Wgtrm::ImportUsers.commit(csv.rows, ignore_emails: ignore_emails)
    end
  end
end
