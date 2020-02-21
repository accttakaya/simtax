Rails.application.routes.draw do
  devise_for :users
  root "functions#index"
  resources :users, only: [:edit, :update]
  post '/about/result1', to: 'about#result1'
  post '/about/result2', to: 'about#result2'
  resources :functions,only: [:show] do
    resources :about,only: [:show]
  end
  resources :mypage,only: [:show]
  

end
