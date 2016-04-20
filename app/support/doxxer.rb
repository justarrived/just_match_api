# frozen_string_literal: true
class Doxxer
  BASE_URL = ENV.fetch('APP_BASE_URL', 'http://localhost:3000')
  EXAMPLE_OUTPUT_PATH = 'examples'
  DOC_PATH = "#{Rails.root}/#{EXAMPLE_OUTPUT_PATH}"
  RESPONSE_PATH = "#{DOC_PATH}/responses"

  RELEVANT_DOC_MODELS = [
    Chat, Comment, Job, User, Message, Language, UserLanguage, Skill, Rating, JobUser,
    JobSkill, UserSkill, Category, HourlyPay, Invoice, Faq, UserImage, Company,
    CompanyImage
  ].freeze

  def self.read_example(model_klass, plural: false, method: nil)
    response = [
      '# Response example',
      File.read(_response_filename(model_klass, plural: plural))
    ]

    with_error = [:create, :update].include?(method)

    error = []
    if with_error
      error_example = File.read(_response_filename(model_klass, error: with_error))
      error = if JSON.parse(error_example).empty?
                []
              else
                ['# Error response example', error_example]
              end
    end

    [response, error].flatten(1).compact.join("\n")
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
    RELEVANT_DOC_MODELS.each do |klass|
      _write_response_example!(klass)
      _write_response_error_example!(klass)
    end
  end

  # private

  def self._response_filename(model_klass, plural: false, error: false)
    model_name = _format_model_name(model_klass, plural: plural)
    file_name = if error
                  "#{model_name}_error"
                else
                  model_name
                end

    "#{RESPONSE_PATH}/#{file_name}.json"
  end

  def self._write_response_example!(model_klass)
    example = _example_for(model_klass)
    File.write(_response_filename(model_klass), example)

    plural_example = _example_for(model_klass, plural: true)
    File.write(_response_filename(model_klass, plural: true), plural_example)
  end

  def self._write_response_error_example!(model_klass)
    example = _error_example_for(model_klass)
    File.write(_response_filename(model_klass, error: true), example)
  end

  def self._example_for(model_klass, plural: false)
    model_attributes = _factory_attributes(model_klass)
    model = model_klass.new(model_attributes)
    model = [model] if plural

    fake_admin = OpenStruct.new(admin?: true, persisted?: true)
    serialized_model = JsonApiSerializer.serialize(model, current_user: fake_admin)
    model_hash = serialized_model.serializable_hash

    # Merge meta attributes for plural examples
    model_hash[:meta] = { total: 1 } if plural

    JSON.pretty_generate(model_hash)
  end

  def self._error_example_for(model_klass)
    model = model_klass.new.tap(&:validate)
    model_hash = model.valid? ? {} : ErrorSerializer.serialize(model)
    JSON.pretty_generate(model_hash)
  end

  def self._format_model_name(model_klass, plural: false)
    name = model_klass.name.underscore.downcase
    if plural
      name.pluralize
    else
      name
    end
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
