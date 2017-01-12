# frozen_string_literal: true
class NewJobCommentNotifier < BaseNotifier
  def self.call(comment:, job:)
    owner = job.owner
    return if ignored?(owner)
    return if owner == comment.owner

    with_locale(owner.locale) do
      JobMailer.
        new_job_comment_email(comment: comment, job: job).
        deliver_later
    end
  end
end
