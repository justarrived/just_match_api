# == Schema Information
#
# Table name: jobs
#
#  id                        :integer          not null, primary key
#  max_rate                  :integer
#  description               :text
#  job_date                  :datetime
#  performed_accept          :boolean          default(FALSE)
#  performed                 :boolean          default(FALSE)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  owner_user_id             :integer
#  latitude                  :float
#  longitude                 :float
#  address                   :string
#  name                      :string
#  estimated_completion_time :float
#  language_id               :integer
#
# Indexes
#
#  index_jobs_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_70cb33aa57  (language_id => languages.id)
#

class JobSerializer < ActiveModel::Serializer
  attributes :id, :max_rate, :description, :job_date, :created_at, :updated_at,
             :performed_accept, :performed, :longitude, :latitude, :name,
             :address, :estimated_completion_time

  has_many :users, key: :applicants
  has_many :comments

  has_one :owner
  has_one :language
end
