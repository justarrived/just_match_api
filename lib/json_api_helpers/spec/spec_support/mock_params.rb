# frozen_string_literal: true

class MockParams
  def initialize(hash)
    @hash = hash
  end

  def [](name)
    @hash[name.to_s]
  end

  def to_h
    @hash
  end
end
