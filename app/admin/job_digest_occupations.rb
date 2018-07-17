# frozen_string_literal: true

ActiveAdmin.register JobDigestOccupation do
  menu parent: 'Job Digests', priority: 3

  permit_params do
    %i[job_digest_id occupation_id]
  end
end
