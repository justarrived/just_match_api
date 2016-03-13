# frozen_string_literal: true
require 'rails-api'

class ApiController < ActionController::API
  include ActionController::Serialization

  def api_render(model_or_model_array, included: [], status: :ok)
    serialized_model = JsonApiSerializer.serialize(
      model_or_model_array,
      included: included
    )

    render json: serialized_model, status: status
  end
end
