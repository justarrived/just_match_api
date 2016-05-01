# frozen_string_literal: true
class TermsAgreementSerializer < ActiveModel::Serializer
  ATTRIBUTES = [:version, :url].freeze
  attributes ATTRIBUTES
end
