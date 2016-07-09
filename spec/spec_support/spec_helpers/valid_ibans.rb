# frozen_string_literal: true
ibans_yaml = File.read('spec/spec_support/data/ibans.yml')
VALID_IBANS = YAML.load(ibans_yaml)['valid_ibans'].freeze
