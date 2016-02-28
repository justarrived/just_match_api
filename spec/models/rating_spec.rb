# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Rating, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
# rubocop:disable Metrics/LineLength
#
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
#  index_ratings_on_from_user_id_and_to_user_id_and_job_id  (from_user_id,to_user_id,job_id) UNIQUE
#  index_ratings_on_to_user_id_and_from_user_id_and_job_id  (to_user_id,from_user_id,job_id) UNIQUE
#
