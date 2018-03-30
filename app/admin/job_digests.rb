# frozen_string_literal: true

ActiveAdmin.register JobDigest do
  menu parent: 'Job Digests', priority: 2

  show do |digest|
    attributes_table do
      row :subscriber
      row :notification_frequency
      row :occupations do
        safe_join(digest.occupations.with_translations.map do |occupation|
          link_to(occupation.display_name, admin_occupation_path(occupation))
        end, ', ')
      end
      row :locale
      row :max_distance
      row :deleted_at
      row :created_at
      row :updated_at
    end

    active_admin_comments
  end

  permit_params do
    %i[
      notification_frequency
      max_distance
      locale
      deleted_at
      digest_subscriber_id
    ]
  end
end
