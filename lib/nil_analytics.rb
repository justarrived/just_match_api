# frozen_string_literal: true
class NilAnalytics
  # Let an instance of fake that its a class
  def new(*)
    self
  end

  def initialize(*)
  end

  def identify(*)
  end

  def track(*)
  end
end
