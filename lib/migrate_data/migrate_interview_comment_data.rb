# frozen_string_literal: true

# Usage:
#   MigrateInteviewCommentData.up(activity_id: 1, author_id: 12)
class MigrateInteviewCommentData
  def self.up(activity_id:, author_id:, scope: User)
    unix_epoc = Time.new(1970, 1, 1, 0, 0, 0, 0)

    scope.
      where.not(interview_comment: [nil, '']).
      find_each(batch_size: 500).each do |user|

      RecruiterActivity.create!(
        activity_id: activity_id,
        author_id: author_id,
        user: user,
        body: user.interview_comment,
        created_at: unix_epoc,
        updated_at: unix_epoc
      )
    end
  end
end
