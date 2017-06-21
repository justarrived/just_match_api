# frozen_string_literal: true

class IndustryTranslation < ApplicationRecord
  belongs_to :industry
  belongs_to :language
end
