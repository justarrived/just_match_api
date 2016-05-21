# frozen_string_literal: true
class FrontendRoutesReader
  attr_reader :routes, :base_url

  def initialize
    @routes = YAML.load_file('config/frontend_routes.yml')['routes']
    @base_url = @routes['base_url']
  end

  def draw(name, **args)
    base_url + routes.fetch(name.to_s) % args
  end
end

FrontendRouter = FrontendRoutesReader.new
