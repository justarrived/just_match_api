Rails.application.routes.draw do
  apipie
  get '/', to: redirect('/api_docs')

  namespace :api do
    namespace :v1 do
      resources :jobs, param: :job_id, except: [:new, :edit, :destroy] do
        member do
          get :matching_users
          resources :comments, module: :jobs, except: [:new, :edit]
        end
      end

      resources :users, param: :user_id, except: [:new, :edit] do
        member do
          get :messages
          post :messages, to: 'users#create_message'
          get :matching_jobs
          resources :comments, module: :users, except: [:new, :edit]
        end
      end

      resources :chats, except: [:new, :edit, :update, :destroy] do
        member do
          get :messages
          post :messages, to: 'chats#create_message'
        end
      end

      resources :languages, except: [:new, :edit]
      resources :user_languages, except: [:new, :edit, :update]
      resources :user_skills, except: [:new, :edit]
      resources :job_skills, except: [:new, :edit]
      resources :job_users, except: [:new, :edit]
      resources :skills, except: [:new, :edit]
    end
  end
end
