# frozen_string_literal: true

ActiveAdmin.register DigestSubscriber do
  menu parent: 'Job Digests', priority: 1

  permit_params do
    %i[
      email
      user_id
      deleted_at
    ]
  end
end
