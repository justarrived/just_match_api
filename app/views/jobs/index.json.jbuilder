json.array!(@jobs) do |job|
  json.extract! job, :id, :max_rate, :description, :job_date, :performed
  json.url job_url(job, format: :json)
end
