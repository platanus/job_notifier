JobNotifier::Engine.routes.draw do
  resources :jobs, only: [:index]
end
