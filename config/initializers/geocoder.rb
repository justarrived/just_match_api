# frozen_string_literal: true

# Configure Geocoder defaults
Geocoder.configure(
  timeout: 3, # seconds
  units: :km,
  api_key: AppSecrets.google_maps_api_token,
  use_https: true
)
