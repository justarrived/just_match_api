# frozen_string_literal: true

class Industry < ApplicationRecord
  belongs_to :language

  include Translatable
  translates :name
end
