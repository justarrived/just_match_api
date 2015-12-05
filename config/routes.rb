Rails.application.routes.draw do
  apipie
  get '/', to: redirect('/api_docs')

  resources :user_skills
  resources :job_skills
  resources :job_users
  resources :jobs do
    member do
      get 'matching_users'
    end
  end
  resources :users
  resources :skills
end
