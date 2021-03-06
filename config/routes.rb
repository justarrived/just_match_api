# frozen_string_literal: true

require 'admin_subdomain'

Rails.application.routes.draw do
  # In production we run the Sidekiq Web UI on a separate server
  if AppConfig.sidekiq_web_enabled?
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
    Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]
  end

  constraints(AdminSubdomain) do
    ActiveAdmin.routes(self)
  end

  apipie
  root to: redirect('/api_docs')

  mount Blazer::Engine, at: 'insights'

  namespace :api do
    namespace :v1 do
      namespace :ahoy do
        resources :events
      end

      resources :jobs, param: :job_id, only: %i(index show create update) do
        collection do
          resources :job_digests, param: :job_digest_id, module: :jobs, path: :digests, only: %i(create) do
            collection do
              get 'notification-frequencies', to: 'notification_frequencies'
            end
          end
          resources :digest_subscribers, param: :digest_subscriber_id, module: :jobs, path: :subscribers, only: %i(show create destroy) do
            member do
              resources :job_digests, param: :job_digest_id, path: :digests, only: %i(index update destroy)
            end
          end
        end

        member do
          get :matching_users, path: 'matching-users'
          resources :job_comments, module: :jobs, path: :comments, only: %i(index show create destroy)
          resources :job_skills, param: :job_skill_id, module: :jobs, path: :skills, only: %i(index show create destroy)
          resources :job_users, param: :job_user_id, module: :jobs, path: :users, only: %i(index show create destroy) do
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
          resources :users, param: :user_id, module: :jobs, only: [] do
            member do
              get :missing_traits, path: 'missing-traits'
              get :job_user, path: 'job-user'
            end
          end
        end
      end

      resources :chats, module: :chats, only: %i(index show create) do
        member do
          resources :chat_messages, path: :messages, only: %i(create index)
        end
      end

      resources :users, param: :user_id, only: %i(index show create update) do
        member do
          resources :messages, module: :users, only: %i(create index)
          resources :user_chats, path: :chats, module: :users, only: %i(index show) do
            collection do
              get :support_chat, path: 'support-chat'
            end
          end

          resources :utalk_codes, path: 'utalk-codes', module: :users, only: %i[index create]

          get :matching_jobs, path: 'matching-jobs'
          resources :user_jobs, path: :jobs, module: :users, only: [:index]
          resources :owned_jobs, path: 'owned-jobs', module: :users, only: [:index]
          resources :user_skills, param: :user_skill_id, module: :users, path: :skills, only: %i(index show create destroy)
          resources :user_occupations, param: :user_occupation_id, module: :users, path: :occupations, only: %i(index show create destroy)
          resources :user_interests, param: :user_interest_id, module: :users, path: :interests, only: %i(index show create destroy)
          resources :user_languages, param: :user_language_id, module: :users, path: :languages, only: %i(index show create destroy)
          resources :user_images, module: :users, path: :images, only: %i(show create)
          resources :ratings, module: :users, path: :ratings, only: [:index]
          resources :user_documents, module: :users, path: :documents, only: %i(index create)

          get :missing_traits, path: 'missing-traits'
          get :available_notifications, path: 'available-notifications'
        end

        collection do
          resources :user_sessions, module: :users, path: :sessions, only: %i(create destroy) do
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

      resources :companies, param: :company_id, only: %i(index create show) do
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

      resources :occupations, only: %i(index show)
      resources :terms_agreement_consents, path: 'terms-consents', only: [:create]
      resources :languages, only: %i(index show create update destroy)
      resources :skills, only: %i(index show create update destroy)
      resources :interests, only: %i(index show)
      resources :categories, only: %i(index show)
      resources :hourly_pays, path: 'hourly-pays', only: %i(index show) do
        collection do
          get :calculate
        end
      end
      resources :faqs, only: [:index]

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

      namespace :partner_feeds, path: 'partner-feeds' do
        namespace :jobs do
          get :linkedin
          get :blocketjobb
          get :metrojobb
        end
      end

      namespace :guides do
        resources :guide_sections, param: :section_id, path: :sections, only: %i(index show) do
          member do
            resources :guide_section_articles, param: :article_id, path: :articles, only: %i(index show)
          end
        end
      end
    end
  end
end
