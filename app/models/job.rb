class Job < ActiveRecord::Base
end

# == Schema Information
#
# Table name: jobs
#
#  id          :integer          not null, primary key
#  max_rate    :integer
#  description :text
#  job_date    :datetime
#  performed   :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
