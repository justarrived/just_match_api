# frozen_string_literal: true

class NewJobCommentNotifier < BaseNotifier
  def self.call(comment:, job:)
    owner = job.owner
    return if owner == comment.owner

    envelope = JobMailer.new_job_comment_email(comment: comment, job: job)
    dispatch(envelope, user: owner, locale: owner.locale)
  end
end
