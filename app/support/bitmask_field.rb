# frozen_string_literal: true

module BitmaskField
  def self.to_mask(new_array, array)
    (new_array & array).map { |r| 2**array.index(r) }.sum
  end

  def self.from_mask(mask, array)
    array.reject { |r| ((mask || 0) & 2**array.index(r)).zero? }
  end
end
