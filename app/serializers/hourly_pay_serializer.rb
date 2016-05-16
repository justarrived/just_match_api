# frozen_string_literal: true
class HourlyPaySerializer < ApplicationSerializer
  ATTRIBUTES = [:rate, :active, :currency].freeze

  attributes ATTRIBUTES
end

# == Schema Information
#
# Table name: hourly_pays
#
#  id         :integer          not null, primary key
#  active     :boolean          default(FALSE)
#  rate       :integer
#  currency   :string           default("SEK")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
