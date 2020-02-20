Rails.application.routes.draw do
  root to: "functions#index"
  post '/about/result1', to: 'about#result1'
  post '/about/result2', to: 'about#result2'
  
  resources :functions,only: [:show] do
    resources :about,only: [:show]
  end

end
