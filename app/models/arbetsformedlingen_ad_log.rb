# frozen_string_literal: true

class ArbetsformedlingenAdLog < ApplicationRecord
  belongs_to :arbetsformedlingen_ad
end

# rubocop:disable Metrics/LineLength
#
# == Schema Information
#
# Table name: arbetsformedlingen_ad_logs
#
#  id                       :integer          not null, primary key
#  arbetsformedlingen_ad_id :integer
#  response                 :json
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
# Indexes
#
#  index_arbetsformedlingen_ad_logs_on_arbetsformedlingen_ad_id  (arbetsformedlingen_ad_id)
#
# Foreign Keys
#
#  fk_rails_...  (arbetsformedlingen_ad_id => arbetsformedlingen_ads.id)
#
#
# rubocop:enable Metrics/LineLength
