# frozen_string_literal: true
module ENVTestHelper
  # NOTE: should mock instead of mutating
  def self.wrap(env_map)
    old_env_map = {}
    env_map.each do |var_sym, value|
      var = var_sym.to_s
      old_env_map[var] = ENV[var]
      ENV[var] = value
    end

    yield

    old_env_map.each { |var, old_value| ENV[var] = old_value }
  end
end
