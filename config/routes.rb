Rails.application.routes.draw do
  root 'users#new'

  resources :user_skills
  resources :job_skills
  resources :job_users
  resources :jobs
  resources :users
  resources :skills
end
