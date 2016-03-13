# frozen_string_literal: true
class Doxxer
  BASE_URL = 'https://just-match-api.herokuapp.com'
  EXAMPLE_OUTPUT_PATH = 'examples'
  DOC_PATH = "#{Rails.root}/#{EXAMPLE_OUTPUT_PATH}"
  RESPONSE_PATH = "#{DOC_PATH}/responses"

  RELEVANT_DOC_MODELS = [
    Chat, Comment, Job, User, Message, Language, UserLanguage, Skill, Rating, JobUser
  ].freeze

  def self.read_example(model_klass)
    [
      '# Example response',
      File.read(_response_filename(model_klass))
    ].join("\n")
  end

  def self.curl_for(name:, id: nil, with_auth: false, join_with: ' ')
    path = [name, id].compact.join('/')
    curl_opts = []
    if with_auth
      curl_opts << "-H 'Authorization: Token token=YOUR_TOKEN'"
    end
    curl_opts << "-X GET #{BASE_URL}/api/v1/#{path}.json"
    curl_opts << '-s'
    "$ curl #{curl_opts.join(join_with)} | python -mjson.tool"
  end

  def self.generate_response_examples
    RELEVANT_DOC_MODELS.each { |klass| _write_response_example!(klass) }
  end

  # private

  def self._response_filename(model_klass)
    "#{RESPONSE_PATH}/#{_format_model_name(model_klass)}.json"
  end

  def self._write_response_example!(model_klass)
    FileUtils.mkdir_p(RESPONSE_PATH)

    example = _example_for(model_klass)
    File.write(_response_filename(model_klass), example)
  end

  def self._example_for(model_klass)
    model_attributes = _factory_attributes(model_klass)
    model = model_klass.new(model_attributes)

    serialized_model = ActiveModel::SerializableResource.new(model)
    model_hash = serialized_model.serializable_hash
    JSON.pretty_generate(model_hash)
  end

  def self._format_model_name(model_klass)
    model_klass.name.underscore.downcase
  end

  def self._factory_attributes(model_klass)
    model_name = _format_model_name(model_klass)
    begin
      FactoryGirl.attributes_for("#{model_name}_for_docs")
    rescue ArgumentError => e
      if e.message.start_with?('Factory not registered:')
        return FactoryGirl.attributes_for(model_name)
      end

      raise e
    end
  end
end
