# frozen_string_literal: true
RSpec::Matchers.define :have_tracked do |event_name|
  match do |backend|
    @event_name = event_name
    @backend = backend

    backend.tracked_events_for(@user).named(@event_name).has_properties?(@properties)
  end

  description do
    'tracked event'
  end

  failure_message do |_text|
    "expected event '#{@event_name}' to be tracked for user '#{@user}' with included properties #{@properties} but was not" # rubocop:disable Metrics/LineLength
  end

  failure_message_when_negated do |_text|
    "expected event '#{@event_name}' not to be tracked for user '#{@user}' with included properties #{@properties} but was" # rubocop:disable Metrics/LineLength
  end

  chain(:for_user) { |user| @user = user }
  chain(:with_properties) { |properties| @properties = properties }
end

RSpec::Matchers.define :have_identified do |user|
  match do |backend|
    @user = user
    @backend = backend
    @traits ||= {}

    backend.has_identified?(@user, @traits)
  end

  description do
    'identified user'
  end

  failure_message_for_should do |_text|
    "expected identification of user '#{@user}' with traits #{@traits}, who was not"
  end

  failure_message_for_should_not do |_text|
    "expected no identification of user '#{@user}' with traits #{@traits}, who was"
  end

  chain(:with_traits) { |traits| @traits = traits }
end
