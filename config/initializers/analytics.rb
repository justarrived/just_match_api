# frozen_string_literal: true
unless Rails.configuration.x.active_analytics_tracking
  require 'nil_analytics'

  Analytics.backend = NilAnalytics.new
end
