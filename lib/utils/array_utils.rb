# frozen_string_literal: true
class ArrayUtils
  def self.most_common(array)
    array.max_by { |i| array.count(i) }
  end
end
