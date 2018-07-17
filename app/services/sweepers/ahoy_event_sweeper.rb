# frozen_string_literal: true

module Sweepers
  module AhoyEventSweeper
    def self.destroy_old(before_date:, scope: Ahoy::Event)
      scope.where('time < ?', before_date).
        find_each(batch_size: 500, &:destroy)
    end
  end
end
