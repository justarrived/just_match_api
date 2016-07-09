# frozen_string_literal: true
require 'sidekiq/web'

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  User.find_by_credentials(email_or_phone: username, password: password)
end

Rails.application.routes.draw do
  namespace :admin do
    resources :jobs
    resources :invoices
    resources :frilans_finans_invoices
    resources :job_users
    resources :ratings
    resources :users
    resources :companies
    resources :contacts
    resources :faqs
    resources :hourly_pays
    resources :languages
    resources :terms_agreements
    resources :terms_agreement_consents
    resources :comments
    resources :chats
    resources :messages
    resources :user_images
    resources :company_images
    resources :categories
    resources :user_languages
    resources :chat_users
    resources :skills
    resources :job_skills
    resources :user_skills
    resources :frilans_finans_terms

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
          resources :chats, module: :users, only: [:index, :show]

          get :matching_jobs, path: 'matching-jobs'
          resources :user_jobs, path: :jobs, module: :users, only: [:index]
          resources :owned_jobs, path: 'owned-jobs', module: :users, only: [:index]
          resources :user_skills, param: :user_skill_id, module: :users, path: :skills, only: [:index, :show, :create, :destroy]
          resources :user_languages, param: :user_language_id, module: :users, path: :languages, only: [:index, :show, :create, :destroy]
          resources :frilans_finans, path: 'frilans-finans', module: :users, only: [:create]
          resources :user_images, module: :users, path: :images, only: [:show]
          resources :ratings, module: :users, path: :ratings, only: [:index]
        end

        collection do
          get :company_users_count

          resources :user_sessions, module: :users, path: :sessions, only: [:create, :destroy] do
            collection do
              post :magic_link, path: 'magic-link'
            end
          end
          resources :reset_password, path: 'reset-password', module: :users, only: [:create]
          resources :change_password, path: 'change-password', module: :users, only: [:create]
          resources :user_images, module: :users, path: :images, only: [:create]

          get :notifications
        end
      end

      resources :chats, only: [:index, :show, :create] do
        member do
          resources :messages, module: :chats, only: [:create, :index]
        end
      end

      resources :companies, param: :company_id, only: [:index, :create, :show] do
        member do
          resources :company_images, module: :companies, path: :images, only: [:show]
        end

        collection do
          resources :company_images, module: :companies, path: :images, only: [:create]
        end
      end

      resources :terms_agreements, path: 'terms-agreements', only: [] do
        collection do
          get :current
          get :'current-company'
        end
      end

      resources :terms_agreement_consents, path: 'terms-consents', only: [:create]
      resources :languages, only: [:index, :show, :create, :update, :destroy]
      resources :skills, only: [:index, :show, :create, :update, :destroy]
      resources :categories, only: [:index]
      resources :hourly_pays, path: 'hourly-pays', only: [:index]
      resources :faqs, only: [:index]
      resources :promo_codes, path: 'promo-codes', only: [] do
        collection do
          post :validate
        end
      end

      post :contacts, to: 'contacts#create'
    end
  end
end
