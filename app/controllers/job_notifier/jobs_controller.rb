module JobNotifier
  class JobsController < ActionController::Base
    skip_before_action :verify_authenticity_token

    def index
      jobs = Job.unnotified_by_identifier!(params[:identifier])
      render json: jobs
    end
  end
end
