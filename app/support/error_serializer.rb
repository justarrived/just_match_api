# frozen_string_literal: true
module ErrorSerializer
  def self.serialize(model)
    model.errors.messages.map do |field, errors|
      errors.map do |error_message|
        {
          status: 422,
          source: { pointer: "/data/attributes/#{field}" },
          detail: error_message
        }
      end
    end.flatten
  end
end
