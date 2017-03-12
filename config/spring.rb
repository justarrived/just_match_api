# frozen_string_literal: true
%w(
  .ruby-version
  .rbenv-vars
  tmp/restart.txt
  tmp/caching-dev.txt
  config/frontend_routes.yml
).each { |path| Spring.watch(path) }
