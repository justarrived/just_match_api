# frozen_string_literal: true
# If the regressor gem is inside a group wrap your initializer in
if defined?(Regressor)
  Regressor.configure do |config|
    config.regression_path = 'spec/models/regression'
    config.regression_controller_path = 'spec/controllers/regression'

    # Provide model names as String (e.g. 'User')
    config.excluded_models = []

    # Provide controller names as String (e.g. 'UsersController').
    config.excluded_controllers = []

    config.include_enums = true
  end
end
