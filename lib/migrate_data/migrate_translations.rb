# frozen_string_literal: true
module MigrateTranslations
  BATCH_SIZE = 100

  MODELS_DATA = [
    ['Comment', [:body]],
    ['Message', [:body]],
    ['Job', [:name, :description, :short_description]],
    ['JobUser', [:apply_message]],
    ['User', [:description, :education, :competence_text, :job_experience]]
  ].freeze

  def self.down
    MODELS_DATA.each do |klass_name, attributes|
      Rails.logger.info "Down migration for #{klass_name}"
      down_model(klass_name.constantize, attributes)
    end
  end

  def self.up
    MODELS_DATA.each do |klass_name, attributes|
      Rails.logger.info "Up migration for #{klass_name}"
      up_model(klass_name.constantize, attributes)
    end
  end

  def self.up_model(model_klass, attributes)
    process_each(model_klass, attributes, :up) do |model, model_attributes|
      model.set_translation(model_attributes, model.language_id)
    end
  end

  def self.down_model(model_klass, _attributes)
    # Set model attributes from stored translation
    # process_each(model_klass, _attributes, :down) do |model, model_attributes|
    #   model.assign_attributes(model_attributes)
    #   model.save(validate: false)
    # end

    "#{model_klass.name}Translation".constantize.delete_all
  end

  def self.process_each(model_klass, attributes, direction)
    model_klass.find_each(batch_size: BATCH_SIZE) do |model|
      process(model, attributes, direction) do |model_attributes|
        yield(model, model_attributes)
      end
    end
  end

  def self.process(model, attributes, direction)
    return if model.language_id.nil?

    base_model = direction == :up ? model : model.original_translation

    model_attributes = attributes.map do |attribute|
      [attribute, base_model[attribute]]
    end.to_h

    yield(model_attributes)
  end
end
