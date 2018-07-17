# frozen_string_literal: true

class RecruiterActivity < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'author_id', inverse_of: :owner_recruiter_activities # rubocop:disable Metrics/LineLength
  belongs_to :user, inverse_of: :recruiter_activities
  belongs_to :activity
  belongs_to :document, optional: true

  accepts_nested_attributes_for :document
end

# == Schema Information
#
# Table name: recruiter_activities
#
#  activity_id :bigint(8)
#  author_id   :integer
#  body        :text
#  created_at  :datetime         not null
#  document_id :bigint(8)
#  id          :bigint(8)        not null, primary key
#  updated_at  :datetime         not null
#  user_id     :bigint(8)
#
# Indexes
#
#  index_recruiter_activities_on_activity_id  (activity_id)
#  index_recruiter_activities_on_author_id    (author_id)
#  index_recruiter_activities_on_document_id  (document_id)
#  index_recruiter_activities_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (activity_id => activities.id)
#  fk_rails_...  (document_id => documents.id)
#  fk_rails_...  (user_id => users.id)
#
