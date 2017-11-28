# frozen_string_literal: true

class UtalkCodeSerializer < ApplicationSerializer
  ATTRIBUTES = %i[code claimed_at].freeze
  attributes ATTRIBUTES

  link(:self) { api_v1_utalk_codes_url(user_id: object.user.id) }

  belongs_to :user do
    link(:related) { api_v1_user_url(user_id: object.user.id) }
  end

  attribute :signup_url
end

# == Schema Information
#
# Table name: utalk_codes
#
#  id         :integer          not null, primary key
#  code       :string
#  user_id    :integer
#  claimed_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_utalk_codes_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
