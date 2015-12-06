Rails.application.routes.draw do
  apipie
  get '/', to: redirect('/api_docs')

  namespace :api do
    namespace :v1 do
      resources :jobs, except: [:new, :edit] do
        member do
          get 'matching_users'
        end
      end

      resources :users, except: [:new, :edit] do
        member do
          get 'matching_jobs'
          resources :languages, except: [:new, :edit]
        end
      end

      resources :comments, except: [:new, :edit]
      resources :user_languages, except: [:new, :edit]
      resources :user_skills, except: [:new, :edit]
      resources :job_skills, except: [:new, :edit]
      resources :job_users, except: [:new, :edit]
      resources :skills, except: [:new, :edit]
    end
  end
end
