# frozen_string_literal: true
require 'sidekiq/web'

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  User.find_by_credentials(email: username, password: password)
end

Rails.application.routes.draw do
  namespace :admin do
    resources :categories
    resources :chats
    resources :comments
    resources :companies
    resources :contacts
    resources :hourly_pays
    resources :invoices
    resources :jobs
    resources :users
    resources :messages
    resources :languages
    resources :user_languages
    resources :skills
    resources :chat_users
    resources :job_skills
    resources :job_users
    resources :user_skills
    resources :ratings

    root to: 'jobs#index'
  end

  apipie
  get '/', to: redirect('/api_docs')

  mount Blazer::Engine, at: 'insights'
  mount Sidekiq::Web, at: 'sidekiq'

  namespace :api do
    namespace :v1 do
      resources :jobs, param: :job_id, only: [:index, :show, :create, :update] do
        member do
          get :matching_users, path: 'matching-users'
          resources :job_comments, module: :jobs, path: :comments, only: [:index, :show, :create, :update, :destroy]
          resources :job_skills, param: :job_skill_id, module: :jobs, path: :skills, only: [:index, :show, :create, :destroy]
          resources :job_users, param: :job_user_id, module: :jobs, path: :users, only: [:index, :show, :create, :update, :destroy] do
            member do
              resources :invoices, only: [:create]
            end
          end
          resources :ratings, module: :jobs, path: :ratings, only: [:create]
        end
      end

      resources :users, param: :user_id, only: [:index, :show, :create, :update, :destroy] do
        member do
          resources :messages, module: :users, only: [:create, :index]

          get :matching_jobs, path: 'matching-jobs'
          resources :user_jobs, path: :jobs, module: :users, only: [:index]
          resources :user_skills, param: :user_skill_id, module: :users, path: :skills, only: [:index, :show, :create, :destroy]
          resources :user_languages, param: :user_language_id, module: :users, path: :languages, only: [:index, :show, :create, :destroy]
          resources :frilans_finans, path: 'frilans-finans', module: :users, only: [:create]
        end

        collection do
          resources :user_sessions, module: :users, path: :sessions, only: [:create, :destroy]
          resources :reset_password, path: 'reset-password', module: :users, only: [:create]
          resources :change_password, path: 'change-password', module: :users, only: [:create]
          get :notifications
        end
      end

      resources :chats, only: [:index, :show, :create] do
        member do
          resources :messages, module: :chats, only: [:create, :index]
        end
      end

      resources :languages, only: [:index, :show, :create, :update, :destroy]
      resources :skills, only: [:index, :show, :create, :update, :destroy]
      resources :categories, only: [:index]
      resources :hourly_pays, path: 'hourly-pays', only: [:index]

      post :contacts, to: 'contacts#create'
    end
  end
end
