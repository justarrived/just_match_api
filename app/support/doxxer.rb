class Doxxer
  BASE_URL = 'https://just-match-api.herokuapp.com'

  def self.example_for(model_klass)
    model = ActiveModel::SerializableResource.new(model_klass.new)
    model_hash = model.serializable_hash
    [
      "# Example response JSON",
      JSON.pretty_generate(model_hash)
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
end
