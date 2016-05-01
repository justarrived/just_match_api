# frozen_string_literal: true
class TermsAgreementSerializer < ActiveModel::Serializer
  ATTRIBUTES = [:version, :url].freeze
  attributes ATTRIBUTES
end

# == Schema Information
#
# Table name: terms_agreements
#
#  id         :integer          not null, primary key
#  version    :string
#  url        :string(2000)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
