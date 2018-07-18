# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecruiterActivity, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
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
#  job_id      :bigint(8)
#  updated_at  :datetime         not null
#  user_id     :bigint(8)
#
# Indexes
#
#  index_recruiter_activities_on_activity_id  (activity_id)
#  index_recruiter_activities_on_author_id    (author_id)
#  index_recruiter_activities_on_document_id  (document_id)
#  index_recruiter_activities_on_job_id       (job_id)
#  index_recruiter_activities_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (activity_id => activities.id)
#  fk_rails_...  (document_id => documents.id)
#  fk_rails_...  (job_id => jobs.id)
#  fk_rails_...  (user_id => users.id)
#
