IncludeParams = Struct.new(:include_param)
class IncludeParams
  def permit(*permitted_includes)
    include_array = (include_param || '').split(',')
    include_array & permitted_includes.flatten(1)
  end
end
