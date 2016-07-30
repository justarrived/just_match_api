# frozen_string_literal: true
class MockParams < Hash
  def initialize(data)
    @data = data
  end

  def [](name)
    @data[name.to_s]
  end
end
