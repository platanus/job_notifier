module JobNotifier
  class JobsController < ActionController::Base
    def index
      jobs = Job.unnotified_by_identifier!(params[:identifier])
      render json: jobs
    end
  end
end
