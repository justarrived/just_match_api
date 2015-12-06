if defined?(Regressor)
  Regressor.configure do |config|
    config.regression_path = 'spec/models/regression'
    config.regression_controller_path = 'spec/controllers/regression'

    config.include_enums = true
  end
end
