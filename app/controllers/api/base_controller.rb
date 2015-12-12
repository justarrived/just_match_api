class Api::BaseController < ApplicationController
  def current_user
    User.first || User.new
  end
end
