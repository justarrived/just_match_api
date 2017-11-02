# frozen_string_literal: true

module ActiveAdmin
  module Inputs
    module Filters
      class DateRangeInput < ::Formtastic::Inputs::StringInput
        def input_html_options(input_name = gt_input_name, extra_class = '')
          value = @object.send(input_name)
          {
            size: 12,
            class: "date-range-picker #{extra_class}",
            max: 10,
            value: value.respond_to?(:strftime) ? value.strftime('%Y-%m-%d') : ''
          }
        end
      end
    end
  end
end
