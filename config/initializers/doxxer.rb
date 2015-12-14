class Doxxer
  BASE_URL = 'https://just-arrived.herokuapp.com'
  def self.example_for(model_klass)
    model = ActiveModel::SerializableResource.new(model_klass.new)
    JSON.pretty_generate(model.serializable_hash)
  end

  def self.curl_for(name:, id: nil)
    path = [name, id].compact.join('/')
    "curl -X GET #{BASE_URL}/api/v1/#{path}.json -s | python -mjson.tool"
  end
end
