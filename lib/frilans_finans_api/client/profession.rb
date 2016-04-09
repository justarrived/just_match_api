# frozen_string_literal: true

module FrilansFinansApi
  class Profession
    ATTRIBUTES = [:title, :ssyk, :insurance_status_id]

    Professions = Struct.new(:resources, :total_pages)

    def self.index(page: 1)
      response = Request.new(page: page).professions
      json = response.body

      parsed = Deserializer.parse(json)
      total_pages = Deserializer.total_pages(json)

      resources = Deserializer.format_array(parsed, ATTRIBUTES)
      Professions.new(resources, total_pages)
    end
  end
end
