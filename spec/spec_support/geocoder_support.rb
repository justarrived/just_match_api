# frozen_string_literal: true
Geocoder.configure(lookup: :test)
Geocoder::Lookup::Test.set_default_stub(
  [
    {
      'latitude'     => 40.7143528,
      'longitude'    => -74.0059731,
      'coordinates'  => [40.7143528, -74.0059731],
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
      'coordinates'  => [59.32932, 18.06858],
      'address'      => 'Stockholm, Sweden',
      'state'        => '',
      'state_code'   => '',
      'country'      => 'Sweden',
      'country_code' => 'SE'
    }
  ]
)

Geocoder::Lookup::Test.add_stub(
  '223 52, Sverige', [
    {
      'latitude'     => 55.6987817,
      'longitude'    => 13.1975525,
      'coordinates'  => [55.6987817, 13.1975525],
      'address'      => '22352, Sverige',
      'state'        => '',
      'state_code'   => '',
      'country'      => 'Sweden',
      'country_code' => 'SE'
    }
  ]
)

Geocoder::Lookup::Test.add_stub(
  'Bankgatan 14C, 223 52, Sverige', [
    {
      'latitude'     => 55.6997802,
      'longitude'    => 13.1953695,
      'coordinates'  => [55.6997802, 13.1953695],
      'address'      => 'Bankgatan 14C, Lund, 22352, Sverige',
      'state'        => '',
      'state_code'   => '',
      'country'      => 'Sweden',
      'country_code' => 'SE'
    }
  ]
)

Geocoder::Lookup::Test.add_stub(
  'watdress', [
    {
      'latitude'     => nil,
      'longitude'    => nil,
      'coordinates'  => [],
      'address'      => '',
      'state'        => '',
      'state_code'   => '',
      'country'      => '',
      'country_code' => ''
    }
  ]
)
