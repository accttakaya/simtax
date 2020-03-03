Rails.application.routes.draw do
  devise_for :users
  root "functions#index"
  resources :users, only: [:edit, :update]
  post '/about/result1', to: 'about#result1'
  post '/about/result2', to: 'about#result2'
  post '/about/result3', to: 'about#result3'
  resources :functions,only: [:show] do
    resources :about,only: [:show]
  end
  resources :mypage,only: [:show]

  get 'inquiry' => 'inquiry#index'
  post 'inquiry/confirm' => 'inquiry#confirm'
  post 'inquiry/thanks' => 'inquiry#thanks'

  resources :groups, only: [:new, :create, :edit, :update, :destroy] do
    resources :messages, only: [:index, :create]
  end

end
