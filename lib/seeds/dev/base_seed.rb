# frozen_string_literal: true
module Dev
  class BaseSeed
    def self.max_count_opt(env_name, default)
      ENV.fetch(env_name, default).to_i
    end

    def self.log(string)
      # rubocop:disable Rails/Output
      puts string
      # rubocop:enable Rails/Output
      Rails.logger.info string
    end
  end
end
