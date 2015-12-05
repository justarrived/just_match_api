Rails.application.routes.draw do
  apipie
  get '/', to: redirect('/api_docs')

  resources :user_skills
  resources :job_skills
  resources :job_users
  resources :jobs
  resources :users
  resources :skills
end
