Rails.application.routes.draw do
  root to: "functions#index"
  post '/functions/result', to: 'functions#result'
  resources :functions,only: [:show]

end
