# frozen_string_literal: true

# Usage:
#   require 'migrate_data/migrate_feedbacks_data'
#   MigrateFeedbacksData.up(activity_id: 1, author_id: 12)
class MigrateFeedbacksData
  def self.up(activity_id:, author_id:, scope: Feedback)
    scope.all.each do |feedback|
      RecruiterActivity.create!(
        activity_id: activity_id,
        author_id: author_id,
        user: feedback.user,
        body: feedback.body,
        created_at: feedback.created_at,
        updated_at: feedback.updated_at
      )
    end
  end
end
