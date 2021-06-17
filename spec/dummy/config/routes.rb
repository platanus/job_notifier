Rails.application.routes.draw do
  mount JobNotifier::Engine => "/job_notifier"
end
