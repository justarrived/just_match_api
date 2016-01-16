# == Schema Information
#
# Table name: user_skills
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  skill_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_user_skills_on_skill_id  (skill_id)
#  index_user_skills_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_59acb6e327  (skill_id => skills.id)
#  fk_rails_fe61b6a893  (user_id => users.id)
#

require 'rails_helper'

RSpec.describe UserSkill, type: :model do
end
