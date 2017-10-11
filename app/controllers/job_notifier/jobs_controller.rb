module JobNotifier
  class JobsController < ActionController::Base
    skip_before_action :verify_authenticity_token, raise: false

    def index
      jobs = Job.by_identifier(params[:identifier])
      jobs = jobs.unnotified if params[:status] == "pending"
      jobs = jobs.notified if params[:status] == "notified"
      render json: jobs
    end

    def update
      job = JobNotifier::Job.find_by!(id: params[:job_id], identifier: params[:identifier])
      job.update_column(:notify, true)
      head :no_content
    end
  end
end
