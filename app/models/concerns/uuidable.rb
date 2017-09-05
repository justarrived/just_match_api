# frozen_string_literal: true

module Uuidable
  extend ActiveSupport::Concern

  included do
    before_validation :set_uuid

    def set_uuid
      return if uuid.present?

      self.uuid = SecureGenerator.uuid
    end
  end
end
