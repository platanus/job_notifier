JobNotifier::Engine.routes.draw do
  resources :jobs, only: [:index]
  resources :adapters, only: [:show]
end
