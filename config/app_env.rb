# frozen_string_literal: true
class AppEnv
  NO_DEFAULT = :a931e53fede62dc64fd24a09a4c9eafa29b63d0982c399be36e6561d5daf63d54a4c

  def initialize(env: ENV)
    @env = env
  end

  def [](key)
    @env[key]
  end

  def []=(key, value)
    @env[key] = value
  end

  def fetch(key, default = NO_DEFAULT)
    return self[key] if key?(key)

    fail(KeyError, "key not found: #{key}") if default == NO_DEFAULT && !block_given?

    return yield if block_given?
    default
  end

  def key?(key)
    @env.key?(key)
  end
end
