# frozen_string_literal: true

require 'spec_support/rails_helpers/runners/spec_runner_helper'

module CheckDBIndexesRunner
  def self.run
    return unless SpecRunnerHelper.execute?('CHECK_DB_INDEXES')

    print 'Checking for missing DB indexes..'

    Rails.application.eager_load!

    keys, warnings = Immigrant::KeyFinder.new.infer_keys

    puts if keys.any? || warnings.values.any?

    warnings.values.each { |warning| $stderr.puts "WARNING: #{warning}" }

    keys.each do |key|
      column = key.options[:column]
      pk = key.options[:primary_key]
      from = "#{key.from_table}.#{column}"
      to = "#{key.to_table}.#{pk}"
      $stderr.puts "Missing foreign key relationship on '#{from}' to '#{to}'"
    end

    if keys.any?
      puts 'Found missing foreign keys:'
      puts [
        'Please run `rails generate immigration AddMissingKeys`',
        'to create a migration to add them.'
      ].join(' ')
      puts 'CheckDBIndexes failed!'
      exit keys.count
    end

    print "done \n"
  end
end
