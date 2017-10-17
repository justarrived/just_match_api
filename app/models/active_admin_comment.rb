# frozen_string_literal: true

class ActiveAdminComment < ActiveRecord::Base
  belongs_to :resource, polymorphic: true
end
