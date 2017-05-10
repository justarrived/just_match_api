# frozen_string_literal: true

require 'utm_url_builder'

class FrontendRouter
  attr_reader :routes, :base_url

  def self.draw(name, **args)
    new.draw(name, **args)
  end

  def initialize
    @routes = YAML.load_file('config/frontend_routes.yml')['routes']
    @base_url = @routes['base_url']
  end

  def draw(name, **args)
    url = base_url + routes.fetch(name.to_s) % args
    url_with_utm_params(url, args)
  end

  def url_with_utm_params(url, params)
    utm_source = params[:utm_source] || UtmUrlBuilder.default_utm_source
    return url unless utm_source

    UtmUrlBuilder.build(
      url,
      source: utm_source,
      medium: params[:utm_medium],
      campaign: params[:utm_campaign],
      term: params[:utm_term],
      content: params[:utm_content]
    )
  end
end
