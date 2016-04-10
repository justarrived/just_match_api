# frozen_string_literal: true
class BaseSeed
  def self.max_count_opt(env_name, default)
    ENV.fetch(env_name, default).to_i
  end

  def max_count_opt(*args)
    self.class.max_count_opt(*args)
  end

  def self.log(string)
    # rubocop:disable Rails/Output
    puts "[db:seed] #{string}"
    # rubocop:enable Rails/Output
    Rails.logger.info string
  end

  def log(*args)
    self.class.log(*args)
  end

  def self.log_seed(*model_klasses)
    model_map = []
    model_klasses.each do |model_klass|
      name = model_klass.name.pluralize
      log "Creating #{name}"
      before_count = model_klass.count

      model_map << {
        before_count: before_count,
        name: name,
        klass: model_klass
      }
    end

    yield

    model_map.each do |model_data|
      name = model_data[:name]
      after_count = model_data[:klass].count
      before_count = model_data[:before_count]
      log "Created #{after_count - before_count} #{name}"
    end
  end

  def log_seed(*args, &block)
    self.class.log_seed(*args, &block)
  end
end
