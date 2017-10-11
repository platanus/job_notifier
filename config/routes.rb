JobNotifier::Engine.routes.draw do
  get ":identifier/jobs/:status", to: "jobs#index"
  get ":identifier/jobs", to: "jobs#index"
  put ":identifier/jobs/notify/:job_id", to: "jobs#update"
end
