# frozen_string_literal: true

class RecruiterActivity < ApplicationRecord
  belongs_to :user
  belongs_to :activity
  belongs_to :document, optional: true

  accepts_nested_attributes_for :document
end

# == Schema Information
#
# Table name: recruiter_activities
#
#  activity_id :bigint(8)
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
#  index_recruiter_activities_on_document_id  (document_id)
#  index_recruiter_activities_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (activity_id => activities.id)
#  fk_rails_...  (document_id => documents.id)
#  fk_rails_...  (user_id => users.id)
#
