# frozen_string_literal: true

class ActiveAdminComment < ApplicationRecord
  belongs_to :resource, polymorphic: true
end

# rubocop:disable Metrics/LineLength
#
# == Schema Information
#
# Table name: active_admin_comments
#
#  id            :integer          not null, primary key
#  namespace     :string
#  body          :text
#  resource_id   :string           not null
#  resource_type :string           not null
#  author_id     :integer
#  author_type   :string
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_active_admin_comments_on_author_type_and_author_id      (author_type,author_id)
#  index_active_admin_comments_on_namespace                      (namespace)
#  index_active_admin_comments_on_resource_type_and_resource_id  (resource_type,resource_id)
#
# rubocop:enable Metrics/LineLength
