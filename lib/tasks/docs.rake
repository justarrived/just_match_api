# frozen_string_literal: true

namespace :docs do
  task api_examples: :environment do
    fail 'Can only generate docs when Rails is in docs env.' unless Rails.env.docs?

    %w(drop create schema:load).each { |task| Rake::Task["db:#{task}"].invoke }
    # load Geocoder stubs (otherwise will end up making tons of network requests..)
    require Rails.root.join('spec', 'spec_support', 'rails_helpers', 'geocoder_support.rb') # rubocop:disable Metrics/LineLength

    Doxxer.generate_response_examples
  end
end
