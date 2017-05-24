# frozen_string_literal: true
%w(
  .ruby-version
  .rbenv-vars
  .env
  tmp/restart.txt
  tmp/caching-dev.txt
  config/frontend_routes.yml
).each { |path| Spring.watch(path) }
