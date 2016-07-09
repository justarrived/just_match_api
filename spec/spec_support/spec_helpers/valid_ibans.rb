# frozen_string_literal: true
ibans = YAML.load_file('spec/spec_support/data/ibans.yml')
VALID_IBANS = ibans['valid_ibans'].freeze
