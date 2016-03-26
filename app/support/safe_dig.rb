# frozen_string_literal: true
module SafeDig
  def self.dig(hash, *keys)
    current_value = hash[keys.shift]

    return unless current_value.is_a?(Hash)

    keys.each do |key|
      current_value = current_value[key] if current_value.is_a?(Hash)
    end

    current_value
  end
end
