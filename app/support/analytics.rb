# frozen_string_literal: true

class Analytics
  def self.track(label, id: nil, data: {}, controller: nil)
    new(controller: controller).
      track(label, id: id, data: data)
  end

  def initialize(controller: nil)
    @tracker = Ahoy::Tracker.new(controller: controller, api: true)
  end

  def track(label, id: nil, data: {})
    data = {
      event_id: id || label,
      event_label: label
    }.merge!(data)
    @tracker.track(label, data)
  end
end
