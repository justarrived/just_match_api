# frozen_string_literal: true

ActiveAdmin.register JobDigest do
  menu parent: 'Job Digests', priority: 2

  permit_params do
    %i[
      address_id
      notification_frequency
      max_distance
      locale
      deleted_at
      digest_subscriber_id
    ]
  end
end
