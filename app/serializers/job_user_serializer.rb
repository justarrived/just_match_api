# frozen_string_literal: true
class JobUserSerializer < ApplicationSerializer
  ATTRIBUTES = [
    :accepted, :accepted_at, :will_perform, :performed, :will_perform_confirmation_by
  ].freeze

  attributes ATTRIBUTES

  belongs_to :user
  belongs_to :job

  has_one :invoice
end

# == Schema Information
#
# Table name: job_users
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  job_id        :integer
#  accepted      :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  will_perform  :boolean          default(FALSE)
#  accepted_at   :datetime
#  performed     :boolean          default(FALSE)
#  apply_message :text
#
# Indexes
#
#  index_job_users_on_job_id              (job_id)
#  index_job_users_on_job_id_and_user_id  (job_id,user_id) UNIQUE
#  index_job_users_on_user_id             (user_id)
#  index_job_users_on_user_id_and_job_id  (user_id,job_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_548d2d3ba9  (job_id => jobs.id)
#  fk_rails_815844930e  (user_id => users.id)
#
