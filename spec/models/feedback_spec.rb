# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Feedback, type: :model do
end

# == Schema Information
#
# Table name: feedbacks
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)
#  job_id     :bigint(8)
#  title      :string
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_feedbacks_on_job_id   (job_id)
#  index_feedbacks_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (job_id => jobs.id)
#  fk_rails_...  (user_id => users.id)
#
