# frozen_string_literal: true

class JobIndustry < ApplicationRecord
  belongs_to :job
  belongs_to :industry
end
