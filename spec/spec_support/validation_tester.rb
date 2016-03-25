# frozen_string_literal: true
class ValidationTester
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  def new_record?
    true
  end

  def persisted?
    false
  end

  def self.name
    'Validator'
  end
end
