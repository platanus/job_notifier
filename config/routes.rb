JobNotifier::Engine.routes.draw do
  get ":identifier/jobs/pending", to: "jobs#index"
  put ":identifier/jobs/notify", to: "jobs#update"
end
