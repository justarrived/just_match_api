# frozen_string_literal: true

# Configure Geocoder defaults
Geocoder.configure(
  timeout: 3, # seconds
  units: :km,
  api_key: ENV['GOOGLE_MAPS_API_TOKEN'],
  use_https: true
)
