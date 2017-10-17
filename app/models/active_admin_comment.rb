# frozen_string_literal: true

class ActiveAdminComment < ApplicationRecord
  belongs_to :resource, polymorphic: true
end
