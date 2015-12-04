json.array!(@job_skills) do |job_skill|
  json.extract! job_skill, :id, :job_id, :skill_id
  json.url job_skill_url(job_skill, format: :json)
end
