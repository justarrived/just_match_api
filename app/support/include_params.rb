# frozen_string_literal: true
class IncludeParams
  attr_reader :include_param

  def initialize(include_param)
    # Underscore the field (JSONAPI attributes are dasherized)
    @include_param = (include_param || '').underscore
  end

  def permit(*permitted_includes)
    include_array = include_param.split(',')
    include_array & permitted_includes.flatten(1)
  end
end
