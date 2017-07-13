# frozen_string_literal: true

class JobCancelledJob < ApplicationJob
  def perform(job:)
    order = job.order
    return unless order

    order.lost = order.jobs.all?(&:cancelled)
    order.save!
  end
end
