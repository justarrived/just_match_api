Rails.application.routes.draw do
  apipie
  get '/', to: redirect('/api_docs')

  namespace :api do
    namespace :v1 do
      resources :jobs, param: :job_id, except: [:new, :edit] do
        member do
          get :matching_users
          resources :comments, module: :jobs, except: [:new, :edit]
        end
      end

      resources :users, param: :user_id, except: [:new, :edit] do
        member do
          get :matching_jobs
          resources :languages, except: [:new, :edit]
          resources :comments, module: :users, except: [:new, :edit]
        end
      end

      resources :user_languages, except: [:new, :edit, :update]
      resources :user_skills, except: [:new, :edit]
      resources :job_skills, except: [:new, :edit]
      resources :job_users, except: [:new, :edit]
      resources :skills, except: [:new, :edit]
    end
  end
end
