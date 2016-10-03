# frozen_string_literal: true
class FakeAnalytics
  # Let an instance of fake that its a class
  def new(*)
    self
  end

  def initialize(*)
    @identified_users = []
    @tracked_events = EventsList.new([])
  end

  def identify(user)
    @identified_users << user
  end

  def track(options)
    @tracked_events << options
  end

  delegate :tracked_events_for, to: :tracked_events

  def has_identified?(user, traits = { email: user.email })
    @identified_users.any? do |user_hash|
      user_hash[:user_id] == user.id &&
        traits.all? do |key, value|
          user_hash[:traits][key] == value
        end
    end
  end

  private

  attr_reader :tracked_events

  class EventsList
    def initialize(events)
      @events = events
    end

    def <<(event)
      @events << event
    end

    def tracked_events_for(user)
      self.class.new(
        events.select do |event|
          event[:user_id] == user.id
        end
      )
    end

    def named(event_name)
      self.class.new(
        events.select do |event|
          event[:event] == event_name
        end
      )
    end

    def has_properties?(options)
      events.any? do |event|
        (options.to_a - event[:properties].to_a).empty?
      end
    end

    private
    attr_reader :events
  end
end
