# frozen_string_literal: true
require 'sidekiq/web'

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  User.find_by_credentials(email_or_phone: username, password: password)
end

# rubocop:disable Metrics/LineLength
Rails.application.routes.draw do
  ActiveAdmin.routes(self)

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
              resources :confirmations, only: [:create]
              resources :acceptances, only: [:create]
              resources :performed, only: [:create]
            end
          end
          resources :calendar, module: :jobs, path: :calendar do
            collection do
              get :google
            end
          end
          resources :ratings, module: :jobs, path: :ratings, only: [:create]
        end
      end

      resources :chats, module: :chats, only: [:index, :show, :create] do
        member do
          resources :chat_messages, path: :messages, only: [:create, :index]
        end
      end

      resources :users, param: :user_id, only: [:index, :show, :create, :update, :destroy] do
        member do
          resources :messages, module: :users, only: [:create, :index]
          resources :user_chats, path: :chats, module: :users, only: [:index, :show]

          get :matching_jobs, path: 'matching-jobs'
          resources :user_jobs, path: :jobs, module: :users, only: [:index]
          resources :owned_jobs, path: 'owned-jobs', module: :users, only: [:index]
          resources :user_skills, param: :user_skill_id, module: :users, path: :skills, only: [:index, :show, :create, :destroy]
          resources :user_interests, param: :user_interest_id, module: :users, path: :interests, only: [:index, :show, :create, :destroy]
          resources :user_languages, param: :user_language_id, module: :users, path: :languages, only: [:index, :show, :create, :destroy]
          resources :frilans_finans, path: 'frilans-finans', module: :users, only: [:create]
          resources :user_images, module: :users, path: :images, only: [:show, :create]
          resources :ratings, module: :users, path: :ratings, only: [:index]
          resources :user_documents, module: :users, path: :documents, only: [:index, :create]
        end

        collection do
          resources :user_sessions, module: :users, path: :sessions, only: [:create, :destroy] do
            collection do
              post :magic_link, path: 'magic-link'
            end
          end
          resources :reset_password, path: 'reset-password', module: :users, only: [:create]
          resources :change_password, path: 'change-password', module: :users, only: [:create]

          post :images
          resources :user_images, module: :users, path: :images, only: [] do
            collection do
              get :categories
            end
          end

          get :notifications
          get :statuses
          get :genders
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
      resources :interests, only: [:index, :show]
      resources :categories, only: [:index, :show]
      resources :hourly_pays, path: 'hourly-pays', only: [:index, :show] do
        collection do
          get :calculate
        end
      end
      resources :faqs, only: [:index]
      resources :promo_codes, path: 'promo-codes', only: [] do
        collection do
          post :validate
        end
      end

      resources :sms, only: [] do
        collection do
          post :receive
        end
      end

      resources :email, only: [] do
        collection do
          post :receive
        end
      end

      resources :documents, only: [:create]

      post :contacts, to: 'contacts#create'
      get :countries, to: 'countries#index'

      get :email_suggestion, to: 'email_suggestions#suggest', path: 'email-suggestion'
      post :email_suggestion, to: 'email_suggestions#suggest', path: 'email-suggestion'
    end
  end
end
# rubocop:enable Metrics/LineLength
