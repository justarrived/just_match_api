# frozen_string_literal: true
class Rating < ActiveRecord::Base
  belongs_to :from_user, class_name: 'User', foreign_key: 'from_user_id'
  belongs_to :to_user, class_name: 'User', foreign_key: 'to_user_id'
  belongs_to :job

  validates :score, presence: true, numericality: { only_integer: true }, inclusion: 1..5
  validates :job, presence: true

  # rubocop:disable Metrics/LineLength
  validates :from_user, presence: true, uniqueness: { scope: :job_id, message: I18n.t('errors.rating.from_user_rated') }
  validates :to_user, presence: true, uniqueness: { scope: :job_id, message: I18n.t('errors.rating.to_user_rated') }
  # rubocop:enable Metrics/LineLength
end

# == Schema Information
#
# Table name: ratings
#
#  id           :integer          not null, primary key
#  from_user_id :integer
#  to_user_id   :integer
#  job_id       :integer
#  score        :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_ratings_on_job_id_and_from_user_id  (job_id,from_user_id) UNIQUE
#  index_ratings_on_job_id_and_to_user_id    (job_id,to_user_id) UNIQUE
#
# Foreign Keys
#
#  ratings_from_user_id_fk  (from_user_id => users.id)
#  ratings_job_id_fk        (job_id => jobs.id)
#  ratings_to_user_id_fk    (to_user_id => users.id)
#
