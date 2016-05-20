Rails.application.routes.draw do
  mount JobNotifier::Engine => "/job_notifier"
  root "home#index"
end
