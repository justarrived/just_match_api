# frozen_string_literal: true
module Queries
  class Filter
    def self.filter(records, filters, filter_types)
      filters.each do |field_name, value|
        filter_type = filter_types[field_name]
        if filter_type
          like_query = extract_like_query(filter_type)
          records = records.where("#{field_name} LIKE concat(#{like_query})", value)
        else
          records = records.where(field_name => value)
        end
      end
      records
    end

    def self.extract_like_query(filter_type)
      case filter_type
      when :contains then "'%', ?, '%'"
      when :starts_with then "?, '%'"
      when :ends_with then "'%', ?"
      else
        raise ArgumentError, "unknown filter_type: '#{filter_type}'"
      end
    end
  end
end
