Rails.application.routes.draw do
  apipie
  get '/', to: redirect('/api_docs')

  resources :jobs do
    member do
      get 'matching_users'
    end
  end

  resources :users do
    member do
      get 'matching_jobs'
    end
  end

  resources :user_skills
  resources :job_skills
  resources :job_users
  resources :skills
end
