# frozen_string_literal: true

module ActiveAdmin
  module Inputs
    class DatetimePickerInput < ::Formtastic::Inputs::StringInput
      def to_html
        input_wrapping do
          label_html << builder.text_field(method, input_html_options)
        end
      end

      def html_class
        'date-time-picker'
      end

      def input_html_options(_input_name = nil, _placeholder = nil)
        options = {}
        options[:class] = [self.options[:class], html_class].compact.join(' ')
        options
      end
    end
  end
end
