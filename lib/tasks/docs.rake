# frozen_string_literal: true
namespace :docs do
  task response_examples: :environment do
    Doxxer.generate_response_examples
  end
end
