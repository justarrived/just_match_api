Geocoder.configure(lookup: :test)
Geocoder::Lookup::Test.set_default_stub(
  [
    {
      'latitude'     => 40.7143528,
      'longitude'    => -74.0059731,
      'address'      => 'New York, NY, USA',
      'state'        => 'New York',
      'state_code'   => 'NY',
      'country'      => 'United States',
      'country_code' => 'US'
    }
  ]
)

Geocoder::Lookup::Test.add_stub(
  'Stockholm', [
    {
      'latitude'     => 59.32932,
      'longitude'    => 18.06858,
      'address'      => 'Stockholm, Sweden',
      'state'        => '',
      'state_code'   => '',
      'country'      => 'Sweden',
      'country_code' => 'SE'
    }
  ]
)
