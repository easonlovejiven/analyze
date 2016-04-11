Rails.application.routes.draw do
  root :to =>'admin/users#index'
  get "/admin" => "admin/users#index"

  devise_for :users, :controllers => { :sessions => "sessions",:registrations => "registrations",:passwords => "passwords",:confirmations => "confirmations" }

  namespace :admin do

    resources :users do
      collection do
        get "/user_password/:id" => "users#passukkkkword"
        post "/more_user" => "users#more_user"
        post "/change_password/:id" => "users#change_password"
      end
    end

    resources :sum_messages do 
      collection do
        post "/more_sum_message" => "sum_messages#more_sum_message"
      end
    end

    resources :documents do
      collection do
        post "/more_document" => "documents#more_document"
      end
    end

  end

  # 通过 /resque 可以访问后台的管理页面
  mount Resque::Server, :at => "/resque"

  # api
  namespace :api do
    namespace :v1 do
      resources :sum_messages do
        collection do
          get "read_file"
        end
      end
    end
  end
  
end
