# frozen_string_literal: true
namespace :docs do
  task api_examples: :environment do
    fail 'Can only generate docs when Rails is in docs env.' unless Rails.env.docs?

    %w(drop create schema:load).each { |task| Rake::Task["db:#{task}"].invoke }

    Doxxer.generate_response_examples
  end
end
