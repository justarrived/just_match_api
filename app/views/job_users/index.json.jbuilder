json.array!(@job_users) do |job_user|
  json.extract! job_user, :id, :user_id, :job_id, :accepted, :role, :rate
  json.url job_user_url(job_user, format: :json)
end
