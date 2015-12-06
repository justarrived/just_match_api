class Api::BaseController < ActionController::API
  include ActionController::Serialization

  def current_user
    User.first || User.new
  end
end
