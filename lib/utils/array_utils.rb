# frozen_string_literal: true
class ArrayUtils
  def self.most_common(array)
    array.max_by { |element| array.count(element) }
  end
end
