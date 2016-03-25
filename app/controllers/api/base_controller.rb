# frozen_string_literal: true
module Api
  class BaseController < ::ApiController
    include Pundit
  end
end
