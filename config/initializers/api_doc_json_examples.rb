class Doxxer
  def self.example_for(model_klass)
    model = ActiveModel::SerializableResource.new(model_klass.new)
    JSON.pretty_generate(model.serializable_hash)
  end
end
